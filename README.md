# kscript-action

A GitHub Action for running unit tests in a [Kscript](https://github.com/holgerbrandl/kscript) project 

# Kscript Unit Test Docker Action

This action will run the unit tests in a [Kscript](https://github.com/holgerbrandl/kscript) project using another helper kscript file for running tests from the command line without IntelliJ. 

## Inputs

### `kts-file`

**Required** The path to the `*.kts` file under test in your Github Project. 

### `kscript-version`

The [kscript version](https://sdkman.io/sdks#kscript) to be used in the action. 

Default value: `'3.1.0'`

### `java-version`

The [JDK](https://sdkman.io/jdks) to be used in the action

Default value: `'11.0.10.hs-adpt'`

### `kotlin-version`

The [Kotlin](https://sdkman.io/) version to be used in the action

Default value: `'1.4.31'`

### `fail-on-failure`

Set to `'false'` to not fail the process if a unit test were to fail and a unit test parser is to be used such as the [JUnit report Github action](https://github.com/marketplace/actions/junit-report-action). 

Default value: 'true'

## Example usage

The kscript-action depends on the [actions/checkout](https://github.com/actions/checkout) as this will checkout out your project into a repository the script is looking for to run the tests from. 

There is also an example [kscript project](https://github.com/plusmobileapps/kotlin-scripting/blob/main/.github/workflows/main.yml) that showcases this action for any pull requests made against the `main` branch.

```yml
on: 
  pull_request:
      branches:
        - main

jobs:
  test:
    runs-on: ubuntu-latest
    name: Run tests in kscript project
    steps:
    - name: Checkout the project into the container
      uses: actions/checkout@v2.3.4
    - name: Run testing script to generate mock IDEA project and run gradle test
      id: hello
      uses: plusmobileapps/kscript-action@v1.1
      with:
        kts-file: 'star-wars-char-enum.kts'
        kscript-version: '3.0.2'
```