# Demonstration SMART / VistA Application
 
This is an example EWD-based application, using EWD's ExtJS v4 tag library.  It demonstrates:

- a UI layout that:
   - lists all the SMART App manifests that are installed on the VistA system
   - provides a center panel in which each SMART App can run within its own iframe


The application is defined as a set of EWD source pages (the files with the .ewd extension).  These should
be placed in a subdirectory of the EWD application root directory and then compiled using EWD's compiler.

The onBeforeRender back-end scripts can be found in the routine file smartVistADemo.m. This should be
moved or copied into an appropriate GT.M routine file directory.

To add a manifest to the VistA system, you need to have installed the SMART EWD application, and run the
manifest management application, eg (depending on your configuration):

- http://127.0.0.1/ewd/SMART/manifests.ewd

To start the smartVistADemo application, again depending on your EWD configuration:

- http://127.0.0.1/ewd/smartVistADemo/login.ewd

You'll be asked to log in using a valid VistA Access Code/Verify Code, and then you must select a patient.
You'll then be able to run any SMART App against that patient's data, provided you have loaded the SMART App's
manifest.
