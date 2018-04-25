#!/usr/bin/env bash
#
# This script takes some inspiration from
# https://github.com/kylemanna/docker-aosp/blob/master/Dockerfile
#
# The MIT License (MIT)
#
# Copyright (c) 2014 Kyle Manna
# Copyright (c) 2018 Franz-Xaver Geiger
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# This script designed to be used a docker ENTRYPOINT "workaround" missing docker
# feature discussed in docker/docker#7198, allow to have executable in the docker
# container manipulating files in the shared volume owned by the USER_ID:GROUP_ID.
#
# It creates a user named `aosp` with selected USER_ID and GROUP_ID (or
# 1000 if not specified).
#
# Example:
#  docker run -ti -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) imagename bash

set -e
set -u

readonly SOURCE_DIR="$(pwd)"

readonly USERNAME="aosp"
groupadd \
	--gid "${GROUP_ID:=1000}" \
	"${USERNAME}"
useradd \
	--gid "${USERNAME}" \
	--uid "${USER_ID:=1000}" \
	--create-home \
	"${USERNAME}"

readonly USER_HOME="$(getent passwd "${USERNAME}" | cut -d: -f6)"
chown \
	"${USERNAME}:${USERNAME}" \
	"${SOURCE_DIR}" \
	"${USER_HOME}"

ARGS="$@"
if [ -z "${ARGS}" ]; then
	ARGS="bash"
	readonly ENVSETUP="${SOURCE_DIR}/build/envsetup.sh"
	if [ -e "${ENVSETUP}" ]; then
		ARGS="${ARGS} --init-file ${ENVSETUP}"
	fi
fi

export HOME="${USER_HOME}"
exec sudo -E -u "${USERNAME}" ${ARGS}
