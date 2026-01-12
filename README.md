# Resolute analysis docker action

This action conducts Resolute analysis on a the named component.

## Inputs

### `component-to-analyze`

**Required** The name of the AADL component to implementation analyze.

### `output-path`

**Required** The absolute output path for the JSON formatted results.

### `workspace-location`

The path to the workspace containing the AADL projects (equivalent to -path option for headless Eclipse).  Default `.`.

### `project-path`

The path, relative to the workspace location, to the directory containing the AADL project.  Default `.`.

### `validation-only`

Perform syntax validation only.  Default `false`.

### `cvs-output`

Generate output in comma-separated values (CSV) format rather than JSON.  Default `false`.

### `exit-on-warning`

Terminate analysis on warnings as well as errors.    Default `false`.

### `supplementaty-aadl`

A space-delimited list of absolute paths to additional AADL files outside the workspace project.  Default none.

### Note

Users installing and running FMIDE locally can invoke command line Resolute analysis with user-supplied shell commands.  This option is not included in the this Action due to security concerns.

## Outputs

### `result`

The JSON-formatted or CSV-formatted summary of analysis results.

## Example usage

~~~
uses: actions/Resolute-CI-Action@v1
with:
  workspace-location: '.'
  component-to-analyze: 'Octocat.impl'
  output-path: '.'
~~~