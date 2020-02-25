# cmus-bt
Bluetooth AVRCP wrapper for [cmus](https://cmus.github.io/).

This is a wrapper script for manipulating an audio player "cmus" using any AVRCP-supported Bluetooth device. This script requires an environment that bluez running on the Linux. and devices used as remote controller must be paired and connected in advance.

## Usage
```
cmus-bt [options] {DEVICE-NAME|DEVICE-ADDRESS}

options:
    -l, --list-available-device
        --log-file=FILE
        --log-level=FLEVEL
```

### options
<dl>
  <dt>-l, --list-available-device</dt>
  <dd>show available device list</dd>
</dl>

### argument
<dl>
  <dt>DEVICE-NAME or DEVICE-ADDRESS</dt>
  <dd>Specify the name or address of the device to use as the remote controler. The list of possible devices can be viewed with the -l option.</dd>
</dl>

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/kwgt/cmus-bt.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

