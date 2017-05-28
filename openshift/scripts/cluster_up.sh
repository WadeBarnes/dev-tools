#!/usr/bin/env bash

# ==============================================================================
# Script for setting up an OpenShift cluter in Docker for Windows
#
# * Requires the OpenShift Origin CLI
# ------------------------------------------------------------------------------
#
# USAGE:  
# cluster_up
#
# ==============================================================================

oc cluster up --host-data-dir=/var/lib/origin/data --use-existing-config