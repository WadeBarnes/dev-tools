# Chocolatey Scripts

These scripts were inspired by the [Chocolatey Development Environment Setup](https://chocolatey.org/docs/development-environment-setup) instructions and the [ferventcoder/setup.ps1](https://gist.github.com/ferventcoder/3825023) gist.

The scripts consist of a batch script and a PowerShell script of the same name; **up**.

The batch script is intended for use on a brand-new environment, one in which PowerShell has never been used or configured.  The PowerShell does all the heavy lifting.

The PowerShell script detects and installs the Chocolatey package manager and then uses Chocolatey to setup an environment using a set of Chocolatey config packages (which can be found in the ./config folder).

# Using the Scripts

For initial setup you should open an administrative cmd prompt and run the `up.cmd` version of the script:
```
./up
```
*This will run the setup in it's default configuration using the `./config/developmentEnv.config` configuration file.*

You can optionally provide the name of another configuration file when running the script.  For example:
```
./up openShift
```
*This will run the setup using the `./config/openShift.config` configuration file.*

The PowerShell version of the script `up.ps1` works the same way and may be used in an environment where PowerShell has already been used and configured.