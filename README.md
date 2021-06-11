
# FWC Camera Ingest


## Purpose

This repository is intended to house example, minimal configurations for the
ingestion of video streams as related to the FWC Coral Spawning project.

## Pre-requisites

*   A working [Docker][docker] set up on the computer intended to run the stream
    ingestion (your workstation, your server, etc.).

*   A working [Docker Compose][docker-compose] installation, capable of
    executing commands like `docker-compose up`.

*   **OPTIONAL**: A working [NVIDIA container runtime][nvidia-docker] to make
    use of hardware-accelerated video stream decoding and encoding.


If you or your organization uses Anaconda (conda), a `environment.yml` file has
been included at the root of this repository in the interest of providing a
contained execution environment (without adversely affecting other application
requirements).

You can use this conda environment by doing the following:

    # With your current directy at the root of this repository
    conda env create

    # Activate the environment
    conda activate fwc-ams

After activating, you should have access to `docker-compose` and other execution
tools necessary for this repository.

## Usage

Out of the box, you should be able to run the following command:

    ./start.sh

This will:

*   Create the necessary Docker volume to provide storage for ingested video
    streams.

*   Build a local Docker image to support the ingestion (named `fwc-ams:latest`
    by default).

*   Using `docker-compose`, start the processes necessary to ingest the
    configured video stream (taking configuration from the `.env` file at the
    root of this repository).

## Configuration

Configuration for the camera ingestion is driven by the `.env` file at the root
of the repository. The `.env` file includes values like the following:

    IMAGE_AMS=fwc-ams:latest
    SW_OR_HW=sw
    CAMERA_URI=/sample/coral.mp4
    CORAL_SPAWN_PREDICT_ENDPOINT=http://coral-spawn-service.local/predict

Descriptions follow:

*   `IMAGE_AMS`, determines the name of the Docker image to be built locally.
    This should not require any changes unless the name conflicts with another
    image you have locally, or you would like to use a different image tagging
    scheme.

*   `SW_OR_HW`, determines whether to invoke commands that make use of
    software-based video trancoding (`sw`) or hardware-based video transcoding
    (`hw`).

    Software-based transcoding should work out of the box without further
    configuration of your computer hosting this service. However, software
    transcoding relies heavily on CPU resources, which can quickly be exhausted
    with additional streams.

    If you find that your CPU resources can't keep up with your video ingestion
    requirements, you may want to consider using a hardware-based transcoding
    solution. At time of writing, NVIDIA has support for accessing GPU resources
    from within Docker containers.

*   `CAMERA_URI`, the URI of the video stream intended for ingestion. This
    should a) be a network location that is accessible from the host running
    this ingestion service and b) a URI that is consumeable by `ffmpeg`. See
    the [ffmpeg Protocols][ffmpeg-protocols] for details.

    To test whether your camera URI can be consumed by `ffmpeg`, run the
    following:

        docker run --rm -e "CAMERA_URI=YOUR_CAMERA_URI" fwc-ams:latest bash -c 'ffprobe -hide_banner -i "$CAMERA_URI"'

    This will issue a command to a container running the `fwc-ams:latest` image
    to run `ffprobe` (a diagnostic utility included with `ffmpeg` within the
    `fwc-ams:latest` container), with an input of your URI. If the URI of your
    camera is valid and accessible, you should be presented with information
    about your camera's video feed.

    A small sample video (`coral.mp4`) is included with this repository to
    provide a reference video that can be ingested without the need for
    consuming a live camera feed. When you are ready to consume a live camera
    feed, you can update the `CAMERA_URI` value to the URI of the live camera
    feed.

    You can test the sample `coral.mp4` video with the following command:

        docker run --rm -e "CAMERA_URI=/sample/coral.mp4" fwc-ams:latest bash -c 'ffprobe -hide_banner -i "$CAMERA_URI"'

    Output of the above command is the following:

        Input #0, mov,mp4,m4a,3gp,3g2,mj2, from '/sample/coral.mp4':
          Metadata:
              major_brand     : isom
              minor_version   : 512
              compatible_brands: isomiso2avc1mp41
              encoder         : Lavf58.45.100
          Duration: 00:00:08.04, start: 0.000000, bitrate: 798 kb/s
          Stream #0:0(und): Video: h264 (avc1 / 0x31637661), yuvj420p(pc, bt709), 720x720, 801 kb/s, 30.23 fps, 59.94 tbr, 12k tbn, 1200 tbc (default)
              Metadata:
              handler_name    : VideoHandler
              vendor_id       : [0][0][0][0]

*   `CORAL_SPAWN_PREDICT_ENDPOINT`, the URI of an HTTP endpoint that can accept
    an image generated from this ingestion. The HTTP endpoint must accept an
    HTTP POST request.


## Extension

By default, this repository is configured to ingest only a single camera (named
`cam1`). Its ingestion details are located under `/cameras/fwc/cam1`, and are
built ingestion and available within the `fwc-ams:latest` image.

Additional cameras can be ingested by copying the `cam1` details from
`/cameras/fwc/cam1`, and updating the `docker-compose.yml` under
`/cameras/fwc/new_camera` to fit with the details of the new camera.

Note that with the default configuration for this repository, a `CAMERA_URI`
variable is set in the root `.env`. With more than one camera ingestion, this
will not be a suitable configuration. It is recommended instead to update the
`.env` files at `/cameras/fwc/<camera>/.env` to reflect each camera's specific
configuration, and to update the root `docker-compose.yml` file to not
override the `CAMERA_URI` when invoking the new camera's configuration, but rely
on the `.env` co-located with the camera's `docker-compose.yml`.


----

[docker]: https://www.docker.com/

[docker-compose]: https://docs.docker.com/compose/install/

[nvidia-docker]: https://docs.docker.com/compose/gpu-support/

[ffmpeg-protocols]: https://ffmpeg.org/ffmpeg-protocols.html









