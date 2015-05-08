#!/bin/bash
find . -name '*.mo' -delete
mkdir -p unicorecmsaponjon/locale

pot-create -o unicorecmsaponjon/locale/unicorecmsaponjon.pot unicorecmsaponjon/

declare -a arr=(
    "eng_GB" "tha_TH" "ind_ID" "swa_TZ" "swa_KE" "fre_FR" "spa_AR" "spa_CO"
    "spa_MX" "hin_IN" "por_PT" "mal_IN" "guj_IN" "tel_IN" "tam_IN" "mar_IN"
    "ben_IN" "ben_BD" "fil_PH")

for lang in "${arr[@]}"
do
    mkdir -p "unicorecmsaponjon/locale/""$lang""/LC_MESSAGES"

    if [ ! -f "unicorecmsaponjon/locale/""$lang""/LC_MESSAGES/unicorecmsaponjon.po" ]; then
        msginit -l $lang -i unicorecmsaponjon/locale/unicorecmsaponjon.pot -o unicorecmsaponjon/locale/$lang/LC_MESSAGES/unicorecmsaponjon.po
    fi

    msgmerge --update unicorecmsaponjon/locale/$lang/LC_MESSAGES/unicorecmsaponjon.po unicorecmsaponjon/locale/unicorecmsaponjon.pot
    msgfmt unicorecmsaponjon/locale/$lang/LC_MESSAGES/*.po -o unicorecmsaponjon/locale/$lang/LC_MESSAGES/unicorecmsaponjon.mo
done
