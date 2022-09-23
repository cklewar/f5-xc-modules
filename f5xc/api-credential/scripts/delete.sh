curl -X 'POST' "$api_url" \
-H 'accept: application/json' \
-H 'Content-Type: application/json' \
-H 'Access-Control-Allow-Origin: *' \
-H "Authorization: APIToken $api_token" \
-H "x-volterra-apigw-tenant: $tenant" \
-d "{
  \"name\": \"$interface_name\",
  \"namespace\": \"$namespace\"
  }"
