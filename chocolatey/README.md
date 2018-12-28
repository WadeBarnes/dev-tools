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

# Using the SetUp Script

The `setup.cmd` script can be used to integrate a specific version of the Chocolatey setup scripts into your project.

1. Copy the `setup.cmd` script into your project.
1. Create a custom Chocolatey package file and place it in a `./config` directory relative to the `setup.cmd` script; `./config/</config>.config` for example.
1. Update the defaults (`DEFAULT_CHOCO_CONFIG` for example) in the `setup.cmd` script to match your configuration.
1. Commit the changes to your project.
1. On the target system;
    1. Pull down a copy of your `setup.cmd` script and configuration.
    1. Run the `setup.cmd` script.

The script will download the versioned copies of the main `up` scripts, and install the packages defined in your configuration file after installing Chocolatey if needed.