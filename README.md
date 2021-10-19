== Purpose of the project == 
The purpose of this project is to use a RPi0 as "adapter" between Si468x
DAB/FM receiver and car stereo.

== How can this be achieved == 
- the RPi0 receives analog data from the Si468x radio receiver and encodes it
  in MP3 format
- the RPi0 implements USB mass-storage function so that the car stereo
  will see it as a standard USB ke
- of course the MP3 file being played will not be a standard file otherwise
  the RPi0's flash space would be filled in a relative short time
    - in facts the file will have a fixed size, but its contect will
      be updated over time in order to stream radio content

== Scheme ==
|------------|             |------|             |--------|
| car stereo | <--(USB)--> | RPi0 | <--(I2S)--> | Si468x |
|------------|             |------|             |--------|

== The trick under the hood ==
How can a single MP3 file stream an hypothetically infinite amount of 
FM radio content?
A special block device (fake-block-device) is added to the kernel as module.
This block device will be/have:
- FAT32, for compatibility with most car stereos
- readonly, since we don't want any player to changed its content
- predefined content through a lookup table (a part from the MP3 content, 
  of course)

Then driver will expose a specific syfs through which MP3 encoded data can
be fed into the fake MP3 file. The MP3 encoding software (ffmpeg) will
write encoded data to this file.

Of course the driver will implement a circular buffer in order to handle
both incoming (ffpmeg) and outcoming (car stereo) requests.

== Tools ==
- "setup-env.sh"
    - git clone the RPi's kernel repository
    - git clone the necessary tools for building the kernel
    - create a docker image for the build
- "start-docker.sh" will launch the docker image. One logged into the image
    - "make-defconfig": builds defconfig for RPi0
    - "make-build-all": will build the kernel
