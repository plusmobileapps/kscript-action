import java.io.BufferedReader
import java.io.File
import java.util.concurrent.TimeUnit
import kotlin.system.exitProcess

/**
 * This script takes the name of another kts script as an argument, builds that script with gradle, and runs
 * its tests via "gradle clean test".
 */

val scriptPath = args.firstOrNull() ?: error("First argument must be a path to a script")
val failOnFailFailure: Boolean = args.getOrNull(1)?.let { it.toBoolean() } ?: true
val originalProjectPath = args.getOrNull(2) ?: error("Third argument should be the project path to copy test results back to")

// Checks for a global path or a relative path
val scriptFile = listOf(File(scriptPath), File("", scriptPath))
    .firstOrNull { it.exists() }
    ?: error("Could not find kts file at $scriptPath")

// This leverages the kscript --idea command to create a project containing all the dependencies for the script,
// which we can then build and test.
// We don't want kscript to actually open Intellij, so we create a local "idea" file that does nothing.
// It is added to the PATH immediately before executing the kscript command since the PATH change
// is only applicable for the life of that process.
// It is  prepended to take precedence over the real idea executable.
val mockIdeaFile = File("idea").apply {
    check(createNewFile()) { "idea file already exists in this directory" }
    setExecutable(true)
    deleteOnExit()
}
val ideaPath = mockIdeaFile.canonicalPath.substringBeforeLast("/")
val projectLocation = "export PATH=\"$ideaPath:\$PATH\"; kscript --idea ${scriptFile.canonicalPath}"
    .execute()
    // We capture the output of the --idea  command since it contains the location of the generated project.
    // kscript prints this info to err instead of stdout
    .stdErr
    .lineSequence()
    .map {
        // Output is like "[kscript] Project set up at /Users/your_name/.kscript/kscript_tmp_project__MyScript.kts_1574748399761"
        it.substringAfter("Project set up at ", "")
    }
    .firstOrNull { it.isNotEmpty() }
    ?: error("Project output not found")

// The generated project does not automatically include a ./gradlew wrapper so we have to test using a global gradle installation
assertInPath("gradle")

println("\nTesting ${scriptFile.canonicalPath}...\n")
"""
    cd $projectLocation
    gradle clean test
""".trimIndent()
    .execute(
        // Inherit is used so that gradle test output is shown in console to the user
        stdoutRedirectBehavior = ProcessBuilder.Redirect.INHERIT,
        stderrRedirectBehavior = ProcessBuilder.Redirect.INHERIT
    ).let { result ->
        if (failOnFailFailure) {
            exitProcess(result.exitCode)
        } else {
            copyTestResultBackToProject()
        }
    }

fun copyTestResultBackToProject() {
    """
        mkdir $originalProjectPath/build
        mv $projectLocation/build/* $originalProjectPath/build
    """.trimIndent()
}

fun assertInPath(executableName: String) {
    "which $executableName"
        .execute()
        .stdOut
        .readLine()
        .let {
            checkOrExit("not found" !in it) {
                "$executableName was not found in PATH. Make sure it is installed globally."
            }
        }
}

fun checkOrExit(condition: Boolean, msg: () -> String) {
    if (!condition) {
        println("Error: ${msg()}")
        exitProcess(1)
    }
}

fun String.execute(
    workingDir: File = File("."),
    timeoutAmount: Long = 120,
    timeoutUnit: TimeUnit = TimeUnit.SECONDS,
    stdoutRedirectBehavior: ProcessBuilder.Redirect = ProcessBuilder.Redirect.PIPE,
    stderrRedirectBehavior: ProcessBuilder.Redirect = ProcessBuilder.Redirect.PIPE
): ProcessResult {

    val processBuilder = ProcessBuilder("/bin/sh", "-c", this)
        .directory(workingDir)
        .redirectOutput(stdoutRedirectBehavior)
        .redirectError(stderrRedirectBehavior)
    return processBuilder.start()
        .apply {
            waitFor(timeoutAmount, timeoutUnit)
            if (isAlive) {
                destroyForcibly()
                println("Command timed out after ${timeoutUnit.toSeconds(timeoutAmount)} seconds: '$this'")
                exitProcess(1)
            }
        }
        .let { process ->
            val stdOut = processBuilder.redirectOutput()?.file()?.bufferedReader() ?: process.inputStream.bufferedReader()
            val stdErr = processBuilder.redirectError()?.file()?.bufferedReader() ?: process.errorStream.bufferedReader()
            ProcessResult(process.exitValue(), stdOut, stdErr)
        }
}

data class ProcessResult(val exitCode: Int, val stdOut: BufferedReader, val stdErr: BufferedReader) {
    companion object {
        const val SUCCESS_EXIT_CODE = 0
    }
    val succeeded: Boolean = exitCode == SUCCESS_EXIT_CODE
    val failed: Boolean = !succeeded
}