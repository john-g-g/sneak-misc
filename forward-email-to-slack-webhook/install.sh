#!/bin/bash

D="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cp $D/email_to_webhook /usr/local/bin/email_to_webhook
chmod +x /usr/local/bin/email_to_webhook

mkdir -p /etc/environment.d

echo "|\"/usr/bin/envdir /etc/environment.d /usr/local/bin/email_to_webhook\"" > /root/.forward

echo "now put your webhook url in /etc/environment.d/SLACK_WEBHOOK_URL"
