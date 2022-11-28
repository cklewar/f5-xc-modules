echo "URL: $api_url"/"$delete_uri"
echo "NAME: $name"

curl -X 'DELETE' "$api_url"/"$delete_uri" 2>/dev/null \
-H 'accept: application/data' \
-H 'Content-Type: application/data' \
-H 'Access-Control-Allow-Origin: *' \
-H "Authorization: APIToken $api_token" \
-H "x-volterra-apigw-tenant: $tenant" \
-d "{
  \"name\": \"$name\",
  \"namespace\": \"$namespace\"
  }"