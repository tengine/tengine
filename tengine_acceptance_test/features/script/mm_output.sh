#!/bin/sh
sleep $1

cat <<EOF
(標準出力に出すための大量の文字列を記述)
EOF

cat <<EOF 1>&2
(標準エラーに出すための大量の文字列を記述)
EOF