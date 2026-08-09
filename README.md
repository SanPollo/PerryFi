**NOTE: This project has now been superseded by [PerryFi 2](https://github.com/SanPollo/PerryFi2), an updated Amstrad PCW wifi card that uses only modern components, and is capable of far greater speeds. This repository is, therefore, no longer maintained.**

# PerryFi

1. [Introduction](#introduction)
2. [Licences](#licences)
3. [Obtaining the PCB](#obtaining-the-pcb)
4. [BOM](#bom)
5. [Connector](#connector)
6. [Flashing the ESP8266](#flashing-the-esp8266)
7. [PerryFi Configuration](#perryfi-configuration)
8. [Command Reference](#command-reference)
9. [Included Software](#included-software)
10. [Building QTERM](#building-qterm)

<br />

## Introduction

PerryFi is a wifi modem expansion for Amstrad PCW computers. It is a PCB based on [VapourSoft](https://github.com/VapourSoft)'s [PCW WiFi Modem](https://github.com/VapourSoft/PCWWiFiModem) schematic. The PCW WiFI Modem combines an [Amstrad CPS8256 serial interface](https://www.cpcwiki.eu/index.php/Amstrad_Serial_Interface#Schematic_and_More_.28CPS8256.29) clone with the [ESP8266](https://en.wikipedia.org/wiki/ESP8266)-based [Retro WiFi Modem](https://github.com/mecparts/RetroWiFiModem) by [mecparts](https://github.com/mecparts). mecparts cites inspiration from a [message thread](https://forum.vcfed.org/index.php?threads/wifi232s-evil-clone.1070412/) on the VCF forums, Paul Rickards's [WiFi232](https://biosrhythm.com/?page_id=1453), and Daniel Jameson's [Virtual Modem for ESP8266](https://github.com/stardot/esp8266_modem).

The PerryFi is designed to plug into the [PCW Backplane](https://github.com/SanPollo/PCWBackplane). While it can technically be plugged directly into the back of the PCW using the expansion edge connector, the connector is wider than the two rows of bins, so this configuration would not be stable. Please check the [Connector](#connector) section for more information.

![image](images/built.jpg)

[Index](#perryfi)

<br />

## Licences

The PerryFi PCB is licensed under the [CERN Open Hardware Licence Version 2: CERN-OHL-S](https://opensource.org/license/cern-ohl-s), as is the rest of the content in this repo. Please make sure you read and understand the terms of this licence if you plan to build, sell or release modified versions of the PerryFi.

The older CP/M utilities included are believed to be in the public domain.

[Index](#perryfi)

<br />

## Obtaining the PCB

You can either order this directly from its project page on PCBWay, or from [downloading the gerbers](gerbers/PerryFiV1.0R.zip), and uploading them to your favourite PCB manufacturer. I highly recommend JLCPCB.

![image](images/pcbrender.png)

[Index](#perryfi)

<br />

## BOM

| Ref | Qty | Part | Source |
| --- | --- | ---- | ------ |
| C1 | 1 | 22uF 16V Electrolytical Capacitor | [Mouser](https://www.mouser.co.uk/ProductDetail/Wurth-Elektronik/860010372002?qs=0KOYDY2FL2%252B9WwJ0SbWRgQ%3D%3D) |
| C2 - C9 | 8 | 0.1uF / 100 nF (104) Ceramic Capacitor | [Mouser](https://www.mouser.co.uk/ProductDetail/Vishay-BC-Components/K104K15X7RF5UL2?qs=rLgk8CAOBHbCqsnkGO2HJA%3D%3D) |
| CONN | 1** | 2x25-pin 90-deg Keyed Male Box Header | [AliExpress](https://www.aliexpress.com/w/wholesale-50-pin-2.54mm-male-connector-right-angle.html) |
| IC1 | 1*** | Z80 DART | [eBay](https://www.ebay.co.uk/sch/i.html?_nkw=z80+dart&_sacat=0&_from=R40&LH_BIN=1&_sop=15) |
| R1 | 1 | 3k3 Resistor | [Mouser](https://www.mouser.co.uk/ProductDetail/Vishay-BC-Components/PR01000103301FA500?qs=doiCPypUmgFDZqxdWEJBZg%3D%3D) |
| SKT IC1 | 1 | 40-pin IC DIP Socket | [Mouser](https://www.mouser.co.uk/ProductDetail/Adam-Tech/ICS-640-T?qs=FG09h9tFCuAGM0DRDA70YA%3D%3D) |
| SKT U1 | 1 | 24-pin IC DIP Socket | [Mouser](https://www.mouser.co.uk/ProductDetail/TE-Connectivity/1-2199298-8?qs=fK8dlpkaUMsSY7Gqcrol0Q%3D%3D) |
| SKT U2 | 2* | 6-pin SIL PIN Socket | [Mouser](https://www.mouser.co.uk/ProductDetail/Adam-Tech/RS1-06-G?qs=HoCaDK9Nz5d%2FRbTZEteJ%252Bw%3D%3D) |
| SKT U3 | 2 | 8-pin SIL PIN Socket | [Mouser](https://www.mouser.co.uk/ProductDetail/Adam-Tech/RS1-08-G?qs=ogqIPVdloe88tnZzSgEOEg%3D%3D) |
| SKT U4 - U6 | 3* | 14-pin IC DIP Socket | [Mouser](https://www.mouser.co.uk/ProductDetail/TE-Connectivity/1-2199298-3?qs=fK8dlpkaUMtBOtVI99wRlQ%3D%3D) |
| SKT U7 | 1 | 16-pin DIP Socket | [Mouser](https://www.mouser.co.uk/ProductDetail/TE-Connectivity/1-2199298-4?qs=fK8dlpkaUMvpL10rY9Abiw%3D%3D) |
| U1 | 1 | 8253 / 8254 Programmable Interval Timer | [eBay](https://www.ebay.co.uk/sch/i.html?_nkw=8253+timer&_sacat=0&_from=R40&LH_BIN=1&_sop=15) |
| U2 | 1 | BOB-12009 3.3 to 5v Bidirectional Logic Converter | [Mouser](https://www.mouser.co.uk/ProductDetail/SparkFun/BOB-12009?qs=WyAARYrbSnb%252BGYLWggQnjQ%3D%3D) |
| U3 | 1 | WEMOS D1 mini | [AliExpress](https://www.aliexpress.com/w/wholesale-wemos-d1-mini.html?spm=a2g0o.home.search.0) |
| U4 | 1 | 74LS74 | [Mouser](https://www.mouser.co.uk/ProductDetail/Texas-Instruments/SN74LS74AN?qs=b0gIXGU74fP41yYZQO4%252BKQ%3D%3D) |
| U5 | 1 | 74LS32 | [Mouser](https://www.mouser.co.uk/ProductDetail/Texas-Instruments/SN74LS32N?qs=q2XTDbzbm6DA9Mnew5GiLA%3D%3D) |
| U6 | 1 | 74LS00 | [Mouser](https://www.mouser.co.uk/ProductDetail/Texas-Instruments/SN74LS00N?qs=spW5eSrOWB6G5wECF%252BEZFA%3D%3D) |
| U7 | 1 | 74LS138 | [Mouser](https://www.mouser.co.uk/ProductDetail/Texas-Instruments/SN74LS138N?qs=j01uVdFEFjG9iU5k7BL8mw%3D%3D) |

\* Optional.

** See [Connector](#connector) section below.

\*** Make sure you order a **Z80 DART** and not a Z80 CPU, or Z80-PIO.

For the two vintage chips, IC1 and U1, to avoid fake vintage chips, I highly recommend buying from a European seller on eBay.

Please note that the **Sources** I have specified are based on research I did after assembling my prototypes, and are there for your convenience. Double-check each component before ordering, and let me know if there are any issues, or if the links were useful by raising an issue.

[Index](#perryfi)

<br />

## Connector

The PerryFi should be connected to the PCW using a [PCW Backplane](https://github.com/SanPollo/PCWBackplane).

However, if you decide to use an edge connector, due to spacing, you will need to bend the pins inwards in order for it to fit. This has not been tested, so your mileage may vary. If you do not wish to build a backplane, a custom ribbon cable is highly recommended.

Note that the box connector will be mounted on the very edge of the PerryFi board. Therefore, it is not possible to solder it flush to the board unless you use something like Blu Tac to raise it up slightly.

[Index](#perryfi)

<br />

## Flashing the ESP8266

The ESP8266 microcontroller on the WEMOS D1 mini needs to be flashed with the correct firmware. All that is required is a USB-A to USB-C data cable (or USB-A to Micro-USB depending on the WEMOS D1 mini clone you bought). Be aware that many of these cables are designed for power only, and do not have their data lines attached. If your computer is unable to see the ESP8266, try another cable.

There is various different ESP8266 firmware to choose from. However, different firmware uses different AT commands, which may break compatibility with existing utilities.

The included firmware was modified from the Retro WiFi Modem project by VapourWare, and has been tweaked slightly by me.

The instructions below only relate to Windows users, and are guidelines only. If you have trouble getting your computer to see the ESP8266, please search the internet for further help.

### Included Firmware

The easiest way to flash the included firmware to the D1 mini's ESP8266 is with the [ESP Easy Flasher](https://github.com/raomin/ESPEasyFlasher) software as you don't need to know the starting address, only the COM port number, and the file name of the firmware.

1. Unplug the PerryFi from the PCW or, preferably, remove the WEMOS D1 mini from the PerryFi.
2. If your D1 mini uses a CH340 for serial, download and install the [CH340 driver](https://www.wch-ic.com/downloads/CH341SER_ZIP.html) before proceeding.
3. Connect the D1 mini into your Windows computer using the relevant USB cable.
4. Right-click on the **Start** menu button, and choose **Device Manager**
5. Expand the **Ports (COM & LPT)** section and look for **DEVICE NAME**. Make a note the COM port number e.g. **COM3**
6. Download the latest version of the ESP Easy Flasher software [from here](https://github.com/raomin/ESPEasyFlasher/releases), and extract it somewhere you can find it.
7. Download latest release of the [PerryZi firmware](https://github.com/SanPollo/PerryZi/releases/latest) for the PerryFi 1.0, and put it in the same folder you extracted ESP Easy Flasher to.
8. Run **FlashESP8266.exe** from the same folder, and choose the COM port number from step 3, and the **.bin** file.
9. Click **Upload to ESP**.

### Building the Firmware

You may wish to tweak the firmware, for example to change the default baud rate, or even to develop it further.

To do this, please see the instructions in the [PerryZi repository](https://github.com/SanPollo/PerryZi).

[Index](#perryfi)

<br />

## PerryFi Configuration

To get started, download the boot disc image for the [PCW 8256](software/perryfi_1.0_boot_8256.dsk) or the [PCW 8256](software/perryfi_1.0_boot_9512.dsk), depending on which type of PCW you own, and copy it to your [Gotek](https://github.com/SanPollo/PCWGotekMod). Boot the PCW from that image, and run **QTERM5F.COM**, which is already configured to the default baud rate of **9600**.

Note that this is the maximum speed for the PerryFi 1.0. Attempting to set the wifi modem firmware to a higher speed will result in an **ERROR** being displayed.

### Connect to your Wifi Network

To join your PerryFi to your wifi network, enter the following command in QTERM:

`AT+CONFIG`

The configuration is menu driven. When you have finished, make sure you answer **y** when asked if you want to save your configuration.

### Test Your Connection

To check everything is working fine, we connect to the [Amstrad BBS](https://amstrad.simulant.uk/) hosted by Simulant.

If you check the BBS page above, you will see that the hostname is `amstrad.simulant.net`, and telnet is listening on port **464**. Therefore, we enter the following command:

`ATDTamstrad.simulant.uk:464`

After a few seconds you should see the welcome page.

At this point, feel free to explore the BBS. If not, simply hang up the connection like so:

`+++ATH`

Note that this can be used at any time when you are connected to a remote computer to drop the connection.

To switch to VT100 emulation, press `[PASTE]` followed by `[V]`. When you want to exit QTERM, press `[PASTE]` and then `Q`.

![image](images/bbsconnect.jpg)

[Index](#perryfi)

<br />

## Command Reference

The PerryFi uses [Hayes-style AT commands](https://en.wikipedia.org/wiki/Hayes_AT_command_set), like an original analogue modem.

For a complete list of AT commands, including more settings, [see the list](https://github.com/SanPollo/PerryZi/wiki/Command-Reference) on the PerryZi wiki.

[Index](#perryfi)

<br />

## Included Software

This [DSK image](software/perryfi_utils.dsk) contains a selection of comms-related software to get you started.

It is beyond the scope of this documentation to describe how each piece of software works. However, I highly recommend [following the guide](https://github.com/VapourSoft/PCWWiFiModem/wiki/NIST-Internet-Time-Service-(ITS)) for setting your PCW's time and date from the internet using NIST on VapourSoft's excellent [PCWWiFIModem wiki](https://github.com/VapourSoft/PCWWiFiModem/wiki).

[Index](#perryfi)

<br />

## Building QTERM

You may wish to build QTERM yourself if you want to change one or more of the default options.

To do this, refer to the instructions in [src/qterm5ae/files/#_READ.ME](src/qterm5ae/files/#_READ.ME)

I recommend using an emulator such as John Elliot's [JOYCE](https://www.seasip.info/Unix/Joyce/), and a tool such as [CIFE](https://github.com/ProgrammingHobby/Cife) to transfer files to and from DSK images.

[Index](#perryfi)