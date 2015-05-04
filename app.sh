# $1: file
# $2: url
# $3: folder
# $4: cookies file
_download_tgz_cookies() {
  [[ ! -d "download" ]]       && mkdir -p "download"
  [[ ! -f "download/${1}" ]]  && wget -O "download/${1}" --cookies=on --load-cookies="${4}" "${2}"
  [[ ! -d "target" ]]         && mkdir -p "target"
  [[   -d "target/${3}" ]]    && rm -v -fr "target/${3}"
  [[ ! -d "target/${3}" ]]    && tar -zxvf "download/${1}" -C target
  return 0
}

### ORACLE COOKIE ###
_build_cookie() {
local USERAGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.122 Safari/537.36"
local POSTDATA

rm -f cookies.txt

wget --debug --verbose --cookies=on --keep-session-cookies --save-cookies=cookies.txt "http://www.oracle.com/webapps/redirect/signon?nexturl=http://www.oracle.com/technetwork/java/embedded/embedded-se/downloads/index.html" --user-agent="${USERAGENT}" -O target/signon.html

POSTDATA=$(sed "s/></>\n</g" target/signon.html | awk -F\" '$1 ~ /input/ && $3 ~ /name/ { printf "%s=%s&", $4, $6 } $1 ~ /\/form/ { exit }')

wget --debug --verbose --cookies=on --keep-session-cookies --load-cookies=cookies.txt --save-cookies=cookies.txt "https://login.oracle.com/mysso/signon.jsp" --user-agent="${USERAGENT}" --post-data="${POSTDATA}" -O target/signon2.html

POSTDATA="$(sed "s/></>\n</g" target/signon2.html | awk -F\" '$1 ~ /input/ && $3 ~ /name/ { printf "%s=%s&", $4, $6 } $1 ~ /\/form/ { exit }')ssousername=bugmenot2009%40mailinator.com&password=Bugmenot2009"

wget --debug --verbose --cookies=on --keep-session-cookies --load-cookies=cookies.txt --save-cookies=cookies.txt "https://login.oracle.com/oam/server/sso/auth_cred_submit" --user-agent="${USERAGENT}" --post-data="${POSTDATA}" -O -

}

### LOCAL JAVA ###
_check_java() {
  if [ ! -f /usr/bin/java ]; then
    sudo apt-get install openjdk-7-jre-headless
  fi
}

### JAVA8 ###
_build_java8() {
local VERSION="8u33"
local BUILD="b05"
local FILE="ejdk-${VERSION}-fcs-linux-arm-sflt.tar.gz"
local URL="http://download.oracle.com/otn/java/ejdk/${VERSION}-${BUILD}/${FILE}"
local FOLDER="ejdk1.8.0_33"

_download_tgz_cookies "${FILE}" "${URL}" "${FOLDER}" cookies.txt
pushd "target/${FOLDER}/bin"
JAVA_HOME=/usr ./jrecreate.sh --dest "${DEST}" --verbose
popd
}

### BUILD ###
_build() {
  _check_java
  _build_java8
  _package
}
