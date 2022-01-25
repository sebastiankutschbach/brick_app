#!/bin/bash
set_num=$1
if [ -z "$set_num" ]; then
    echo 'set_num is not set';
else
    echo "set_num is to $set_num";
fi

alternates=$(curl --silent -X GET --header 'Accept: application/json' --header 'Authorization: key 358f7bbd4575582c621edb5f6778bf5e' https://rebrickable.com/api/v3/lego/sets/$set_num/alternates/?page_size=1000)
#echo $alternates
url_array=$(echo $alternates | jq '.results[].moc_url')
#echo $url_array

mkdir -p ./moc_html/$set_num

for url in $url_array
do
    url_wo_quotes=$(echo $url | tr -d '"')
    moc_name=$(echo $url_wo_quotes | cut -d '/' -f 5)
    curl -o ./moc_html/$set_num/$moc_name.html $url_wo_quotes
done