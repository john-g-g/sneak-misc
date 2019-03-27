# send emails to root to slack

# prerequisites

`apt update && apt -y install git python3 make postfix`

# install

```
mkdir -p /etc/environment.d
git clone https://github.com/sneak/hacks.git /tmp/hacks && \
    cd /tmp/hacks/forward-email-to-slack-webhook && \
    make install
```

and

```
mkdir -p /etc/environment.d
echo 'https://hooks.slack.com/services/XXXXXX/XXXXXXX/xxxxxxxxxxxxxxxx' >
    /etc/environment.d/SLACK_WEBHOOK_URL
```
