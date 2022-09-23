echo "URL: $api_url"/"$delete_uri"
echo "NAME: $name"

curl -X 'POST' "$api_url"/"$delete_uri" \
-H 'accept: application/json' \
-H 'Content-Type: application/json' \
-H 'Access-Control-Allow-Origin: *' \
-H "Authorization: APIToken $api_token" \
-H "x-volterra-apigw-tenant: $tenant" \
-d "{
  \"name\": \"$name\",
  \"namespace\": \"$namespace\"
  }"
