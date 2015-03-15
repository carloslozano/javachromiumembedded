## Background ##

The JCEF project is an extension of the Chromium Embedded Framework project hosted at http://code.google.com/p/chromiumembedded. JCEF maintains a development branch that tracks the most recent CEF release branch. JCEF source code (both native code and Java code) can be built manually as described below.

## Development ##

Ongoing development of JCEF occurs in [trunk](http://code.google.com/p/javachromiumembedded/source/browse/#svn%2Ftrunk). This location tracks the current CEF3 release branch.

Development versions of JCEF can be downloaded from http://javachromiumembedded.googlecode.com/svn/trunk/src.

## Building from Source ##

Building from source code is currently supported on Windows, Linux and Mac OS X for 64-bit Oracle 7 Java targets. 32-bit builds are also possible on Windows and Linux but they are untested.

To build JCEF from source code you must start by configuring your build environment.

1. Install the build prerequisites for your operating system and development environment.

  * Windows - Use a version 1.6.x SVN client as some people have reported problems with version 1.7.x. Version 1.6.x is included with depot\_tools on Windows. A 1.6.X version of TortoiseSVN for Windows can be downloaded [here](http://sourceforge.net/projects/tortoisesvn/files/1.6.16/Application/).
  * Linux - Currently supported distributions include Debian Wheezy, Ubuntu Precise, and related. Newer versions will likely also work but may not have been tested. Required packages include: build-essential, binutils-gold, libgtk2.0-dev.

2. Configure environment settings that will effect the [GYP](http://code.google.com/p/gyp/) build.

  * CEF does not currently support component builds.
  * Windows - JCEF developers are currently using Visual Studio 2010. For this reason building JCEF with other compiler versions may result in compile or runtime errors. If multiple versions of Visual Studio are installed on your system you can set the GYP\_MSVS\_VERSION environment variable to create project files for that version. For example, set the value to "2010" for VS2010 or "2010e" for VS2010 Express. Check the Chromium documentation for the correct value when using other Visual Studio versions.

### Manual Downloading ###

JCEF can be downloaded and built as a manual process.

#### Development ####

These download instructions apply only to the development (trunk) version of JCEF.

1. Install depot\_tools. To avoid potential problems make sure the path is as short as possible and does not contain spaces or special characters.

A. Windows only: Install a version 1.6.X SVN client (see above for a TortoiseSVN 1.6 link) and add it to your PATH.

B. Download depot\_tools via SVN.

```
svn co http://src.chromium.org/svn/trunk/tools/depot_tools
```

C. Add the depot\_tools directory to your PATH. On Windows the depot\_tools path should come before the TortoiseSVN path.

2. Create a JCEF checkout directory (for example, /path/to/jcef). To avoid potential problems make sure the path is as short as possible and does not contain spaces or special characters.

##### SVN workflow: #####

This version of steps 3-7 applies to the SVN workflow only. The SVN workflow is recommended for most users.

3. Configure gclient to use the trunk branch.

```
cd /path/to/jcef
gclient config http://javachromiumembedded.googlecode.com/svn/trunk/src
```

4. Checkout JCEF or update an existing JCEF checkout.

```
cd /path/to/jcef
gclient sync --jobs 8 --force
```

Note that this will fail on initial checkout with a "gyp: Undefined variable jcef\_platform" error. This is expected behavior.

5. Read the [src\cef\third\_party\README.jcef](http://javachromiumembedded.googlecode.com/svn/trunk/src/third_party/cef/README.jcef) file to determine the required CEF3 release branch. Download the most recent build of this branch from http://cefbuilds.com. Extract the contents as described in the README.jcef file. Using the "win64" target as an example, the resulting directory structure should be /path/to/jcef/src/third\_party/cef/win64/cefclient.gyp (and so on).

6. Set up the required gyp environment variables.

  * GYP\_DEFINES:
    * Set _jcef\_platform_ to the desired build ("win32", "win64", "linux32", "linux64", “macosx64”).
    * Set _jdk\_directory_ to the full path to the currently installed JDK7 root directory.
    * Set _target\_arch_ to x64 for the 64-bit Mac OS X build.
  * GYP\_GENERATORS:
    * Ninja is not yet supported.

```
# Windows 64-bit
set GYP_GENERATORS=msvs
set GYP_DEFINES=jcef_platform=win64 jdk_directory="C:\Program Files\Java\jdk1.7.0_25"

# Linux 64-bit
export GYP_GENERATORS=make
export GYP_DEFINES="jcef_platform=linux64 jdk_directory=/usr/lib/jvm/java-7-oracle"

# Mac OS X 64-bit
export GYP_GENERATORS=xcode
export GYP_DEFINES="jcef_platform=macosx64 jdk_directory=/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home target_arch=x64"
```

Mac Only: You can figure out your JDK7 directory via the command line tool java\_home:
```
/usr/libexec/java_home -Fv 1.7.0_40+
```

7. Generate the build project files from the [GYP](http://code.google.com/p/gyp/) configuration.

```
cd /path/to/jcef
gclient runhooks
```

### Manual Building ###

1. Build the JCEF native code (dynamic library and helper executable).

  * Windows - Open the Visual Studio solution file (jcef.sln) and build. If building the "win64" target make sure to set the "Active solution platform" to "x64" under Configuration Manager.
  * Mac OS X - Open the Xcode project file (jcef.xcodeproj) and build the “All(jcef project)” target.
  * Linux - Use the _build.sh_ script.

```
cd /path/to/jcef/src/tools
./build.sh Release
```

2. On Windows and Linux build the JCEF Java classes using the _compile.[bat|sh]_ tool.

```
cd /path/to/jcef/src/tools
compile.bat win64
```

On Mac OS X the JCEF Java classes are already built by Xcode.

3. On Windows and Linux test that the resulting build works using the _run.[bat|sh]_ tool. You can either run the simple example (see java/simple/MainFrame.java) or the detailed one (see java/detailed/MainFrame.java) by appending "detailed" or "simple" to the _run.[bat|sh]_ tool. This example assumes that the "Release" configuration was built in step #1 and that you want to use the detailed example.

```
cd /path/to/jcef/src/tools
run.bat win64 Release detailed
```

On Mac OS X run jcef\_app for the detailed example or jcef\_simple\_app for the simple one. Either use the command-line or double-click on jcef\_app (or jcef\_simple\_app) in Finder.

```
cd /path/to/jcef/src/xcodebuild/Release
open jcef_app.app
```

### Manual Packaging ###

After building the Release configurations you can use the _make\_distrib.[bat|sh]_ script to create a binary distribution.

```
cd /path/to/jcef/src/tools
make_distrib.bat win64
```

If the process succeeds a binary distribution package will be created in the /path/to/jcef/src/binary\_distrib directory. See the README.txt file in that directory for usage instructions.