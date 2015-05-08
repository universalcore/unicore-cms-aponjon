#!/bin/bash
find . -name '*.mo' -delete
mkdir -p unicorecmsaponjon/locale

pot-create -o unicorecmsaponjon/locale/unicorecmsaponjon.pot unicorecmsaponjon/

declare -a arr=("eng_GB" "ben_BD")

for lang in "${arr[@]}"
do
    mkdir -p "unicorecmsaponjon/locale/""$lang""/LC_MESSAGES"

    if [ ! -f "unicorecmsaponjon/locale/""$lang""/LC_MESSAGES/unicorecmsaponjon.po" ]; then
        msginit -l $lang -i unicorecmsaponjon/locale/unicorecmsaponjon.pot -o unicorecmsaponjon/locale/$lang/LC_MESSAGES/unicorecmsaponjon.po
    fi

    msgmerge --update unicorecmsaponjon/locale/$lang/LC_MESSAGES/unicorecmsaponjon.po unicorecmsaponjon/locale/unicorecmsaponjon.pot
    msgfmt unicorecmsaponjon/locale/$lang/LC_MESSAGES/*.po -o unicorecmsaponjon/locale/$lang/LC_MESSAGES/unicorecmsaponjon.mo
done
