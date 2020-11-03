#!/bin/bash

source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

files_url=(
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB-Training_fixed.zip GTSRB-Training_fixed.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Final_Test_GT.zip GTSRB_Final_Test_GT.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Final_Test_Haar.zip GTSRB_Final_Test_Haar.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Final_Test_HOG.zip GTSRB_Final_Test_HOG.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Final_Test_HueHist.zip GTSRB_Final_Test_HueHist.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Final_Test_Images.zip GTSRB_Final_Test_Images.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Final_Training_Haar.zip GTSRB_Final_Training_Haar.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Final_Training_HOG.zip GTSRB_Final_Training_HOG.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Final_Training_HueHist.zip GTSRB_Final_Training_HueHist.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Final_Training_Images.zip GTSRB_Final_Training_Images.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Online-Test-Haar-Sorted.zip GTSRB_Online-Test-Haar-Sorted.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Online-Test-Haar.zip GTSRB_Online-Test-Haar.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Online-Test-HOG-Sorted.zip GTSRB_Online-Test-HOG-Sorted.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Online-Test-HOG.zip GTSRB_Online-Test-HOG.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Online-Test-HueHist-Sorted.zip GTSRB_Online-Test-HueHist-Sorted.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Online-Test-HueHist.zip GTSRB_Online-Test-HueHist.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Online-Test-Images-Sorted.zip GTSRB_Online-Test-Images-Sorted.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Online-Test-Images.zip GTSRB_Online-Test-Images.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Training_Features_Haar.zip GTSRB_Training_Features_Haar.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Training_Features_HOG.zip GTSRB_Training_Features_HOG.zip" \
	"https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Training_Features_HueHist.zip GTSRB_Training_Features_HueHist.zip")

# These urls require login cookies to download the file
git-annex addurl --fast -c annex.largefiles=anything --raw --batch --with-files <<EOF
$(for file_url in "${files_url[@]}" ; do echo "${file_url}" ; done)
EOF
git-annex get --fast -J8
git-annex migrate --fast -c annex.largefiles=anything *

[[ -f md5sums ]] && md5sum -c md5sums
[[ -f md5sums ]] || md5sum $(git-annex list --fast | grep -o " .*") > md5sums
