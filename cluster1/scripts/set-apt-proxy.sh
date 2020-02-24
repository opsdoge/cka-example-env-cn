#!/bin/bash

cat >> /etc/apt/apt.conf.d/proxy.conf <<EOF
Acquire::http::Proxy "$HTTP_PROXY";
Acquire::https::Proxy "$HTTP_PROXY";
EOF
