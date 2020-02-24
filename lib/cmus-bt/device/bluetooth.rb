#! /usr/bin/env ruby
# coding: utf-8

#
# Bluetooth AVRCP wrapper for cmus.
#
#   Copyright (C) 2020 Hiroshi Kuwagata <kgt9221@gmail.com>
#

require 'dbus'

module CMusBt
  module Device
    module Bluetooth
      class << self
        def service
          if not @service
            @service = DBus.system_bus.service("org.bluez")
            @service.introspect
          end

          return @service 
        end
        private :service

        def root
          if not @root
            @root = service["/"]
            @root.introspect
          end

          return @root
        end
        private :root

        def objman
          return @objman ||= root["org.freedesktop.DBus.ObjectManager"]
        end
        private :objman

        def list
          ret = []
          dir = objman.GetManagedObjects()

          dir.each { |path, hash|
            next if not hash.keys.include?("org.bluez.Device1")

            iface = hash["org.bluez.Device1"]

            next if iface["UUIDs"].none? {|id| /^0000110e-/ =~ id}
            next if not iface["Connected"]
            next if not iface["ServicesResolved"]

            ret << {:address => iface["Address"], :name => iface["Name"]}
          }

          return ret
        end
      end
    end
  end
end
