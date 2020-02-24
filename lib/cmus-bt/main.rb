#! /usr/bin/env ruby
# coding: utf-8

#
# Bluetooth AVRCP wrapper for cmus.
#
#   Copyright (C) 2020 Hiroshi Kuwagata <kgt9221@gmail.com>
#

require 'systemu'

module CMusBt
  module App
    class << self
      def availables
        ret = []
        a   = Device::Bluetooth.list
        b   = Device::Input.list

        a.each { |ai|
          b.each {|bi|
            if bi[:name] == ai[:address]
              ret << {
                :address  => ai[:address],
                :name     => ai[:name],
                :dev_file => bi[:dev_file],
              }
            end
          }
        }

        return ret
      end
      private :availables

      def list_device
        list = availables()
       
        if list.empty?
          print("Available device is not exist.\n")

        else
          list.each { |info| 
            print(" %17s    %s\n" % [info[:address], info[:name]])
          }
        end
      end
      private :list_device


      def run_app(targ)
        $logger.info("start #{APP_NAME} version #{CMusBt::VERSION}")
        list = availables()
        if list.empty?
          raise("available device is not exist")
        end

        if targ
          info = list.find {|inf| inf[:address] == targ || inf[:name] == targ}
          raise("specified device is not connected") if not info
        else
          info = list.first
        end

        thread = Thread.fork {Player.daemon(info)}
        status = system("cmus")
        raise("execute cmus failed.") if not status.success?

      ensure
        thread&.raise
        thread&.join
        $logger.info("exit #{APP_NAME}")
      end
      private :run_app

      def start(info)
        case $mode
        when :list_device
          list_device

        when :run_app
          run_app(info)

        else
          raise("Not implement yet")
        end

      rescue Exception => e
        STDERR.print("#{e.message}\n")
        exit(1)
      end
    end
  end
end
