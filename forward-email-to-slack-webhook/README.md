# send emails to root to slack

## slack side

First you must go [here](https://api.slack.com/incoming-webhooks) and create
a new slack app and choose a channel and get a webhook URL.

```
mkdir -p /etc/environment.d
echo 'https://hooks.slack.com/services/XXXXXX/XXXXXXX/xxxxxxxxxxxxxxxx' >
    /etc/environment.d/SLACK_WEBHOOK_URL
```

## prerequisites

```
export DEBIAN_FRONTEND=noninteractive
apt update
apt -y install git python3 make postfix daemontools
```

## install helper

```
mkdir -p /etc/environment.d
git clone https://github.com/sneak/hacks.git /tmp/hacks && \
    cd /tmp/hacks/forward-email-to-slack-webhook && \
    make install
```

## example usage

`apt install -y smartmontools`

Now you'll get a slack notification when your disk is going to die, because
smartmontools emails root by default when it detects problems.
