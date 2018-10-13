#!/bin/bash

tp_list="
CDTP_URL
SIGN_URL
XT_URL
EVN_NM
LT_MM
FORUM_URL
"

wp_list="
CDWP_URL
REPORTSERVICE_URL
EVN_NM
CDWP_PAGE_URL
"

mp_list="
CDMP_URL
SIGN_URL
REPORTSERVICE_URL
EVN_NM
LT_MM
FORUM_URL
CDMP_PAGE_URL
"

cd CDTPWebFrontPage
echo ">>> CDTPWebFrontPage"
for item in ${tp_list}; do
    echo ">>> ${item}"
    grep "${item}" -C0 js/util.min.js
done
cd ..
echo ""

cd CDWPWebFrontPage
echo ">>> CDWPWebFrontPage"
for item in ${wp_list}; do
    echo ">>> ${item}"
    grep "${item}" -C0 js/util.min.js
done
cd ..
echo ""

cd CDMPWebFrontPage
echo ">>> CDMPWebFrontPage"
for item in ${mp_list}; do
    echo ">>> ${item}"
    grep "${item}" -C0 js/util.min.js
done
cd ..
