export DIGITALOCEAN_TOKEN="$(cat ~/Documents/sync/secrets/apis/digitalocean/terraform.apikey.txt)"

terraform apply \
  -var "do_token=${DIGITALOCEAN_TOKEN}" \
  -var "pub_key=$HOME/Documents/sync/secrets/ssh/terraform-bootstrap.pub" \
  -var "pvt_key=$HOME/Documents/sync/secrets/ssh/terraform-bootstrap" \
  -var "ssh_fingerprint=a2:74:1f:87:0b:09:91:ed:f4:a6:b2:8f:c7:9d:f5:95"


