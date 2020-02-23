#! /usr/bin/env ruby
# coding: utf-8

#
# Bluetooth AVRCP wrapper for cmus.
#
#   Copyright (C) 2020 Hiroshi Kuwagata <kgt9221@gmail.com>
#

module CMusBt
  module Device
    module Input
      class << self
        def put_ident(dst, s)
          h = {}

          s.scan(/([[:alpha:]]+)=(\h+)/) { |key, val|
            h[key.downcase.to_sym] = val.to_i
          }

          dst[:ident] = h
        end

        def put_name(dst, s)
          dst[:name] = (/^Name=\"(.*)\"$/ =~ s)? $1: nil
        end

        def put_phys(dst, s)
          dst[:phys] = (/^Phys=(.*)$/ =~ s)? $1: nil
        end

        def put_sysfs(dst, s)
          dst[:sysfs] = (/^Sysfs=(.*)$/ =~ s)? $1: nil
        end

        def put_uniq(dst, s)
          dst[:uniq] = (/^Sysfs=(.*)$/ =~ s)? $1: nil
        end

        def put_handlers(dst, s)
          a = []

          s.split.each { |t|
            if /^event\d+$/ =~ t
              dst[:dev_file] = "/dev/input/#{t}"
            else
              a << t
            end
          }

          dst[:handlers] = a
        end

        def put_bitmap(dst, s)
          h = (dst[:bitmap] || {})

          if /(.+)=(.+)/ =~ s
            h[$1] = $2
          end
        end

        def list
          ret = []

          File.open("/proc/bus/input/devices") { |f|
            info = {}

            f.each_line { |l|
              case l
              when /^I: (.*)$/
                put_ident(info, $1)

              when /^N: (.*)$/
                put_name(info, $1)

              when /^P: (.*)/
                put_phys(info, $1)

              when /^S: (.*)$/
                put_sysfs(info, $1)

              when /^U: (.*)$/
                put_uniq(info, $1)

              when /^H: Handlers=(.*)$/
                put_handlers(info, $1)

              when /^B: (.*)$/
                put_bitmap(info, $1)

              when /^\s*$/
                ret << info
                info = {}
                next
              end
            }

            ret << info if not info.empty?
          }

          return ret
        end
      end
    end
  end
end
