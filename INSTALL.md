
  Building & Installing Haguichi Indicator
  ========================================


  Dependencies
  ------------

  The following development packages are required to build Haguichi Indicator:

   * meson (>= 0.40)
   * valac (>= 0.26)
   * glib-2.0 (>= 2.42)
   * gtk+-3.0 (>= 3.14)
   * appindicator3

  On Debian based distributions you can install these packages by running the following command:

    $ sudo apt install build-essential meson valac libglib2.0-dev libgtk-3-dev libappindicator3-dev


  Building
  --------

  To build Haguichi Indicator, run the following commands:

    $ mkdir build && cd build
    $ meson ..
    $ ninja


  Installing
  ----------

  After Haguichi Indicator has been built, run the following command to install it:

    $ sudo ninja install

