#! /usr/bin/env ruby
# coding: utf-8

#
# Bluetooth AVRCP wrapper for cmus.
#
#   Copyright (C) 2020 Hiroshi Kuwagata <kgt9221@gmail.com>
#

require 'systemu'

module CMusBt
  module Player
    # from struct input_event on <linux/event.h>
    EVENT_STRUCTURE = "l!l!S!S!i!"

    FUNC_TABLE      = {
      200 => :do_play,  # KEY_PLAYCD
      201 => :do_pause, # KEY_PAUSECD
      163 => :do_next,  # KEY_NEXTSONG
      165 => :do_prev,  # KEY_PREVIOUSSONG
    }

    class << self
      def query
        begin
          status, ret = systemu("cmus-remote --query")
          raise if not status.success?

        rescue
          sleep 0.2
          retry
        end

        return ret
      end
      private :query

      def status
        ret = catch { |tag|
          query.each_line {|l| throw tag, $1.to_sym if /^status = (.+)/ =~ l}
        }

        return ret
      end
      private :status

      def read_meta
        ret    = {}
        status = nil

        query.each_line { |l|
          case l
          when /^status (.+)/
            status = $1.to_sym

          when /^file (.+)/
            ret[:file] = File.basename($1)

          when /^tag (.+) (.+)/
            ret[$1.to_sym] = $2
          end
        }

        ret[:name] ||= ret[:file] if status == :playing

        return ret
      end
      private :read_meta

      def do_play
        if status == :playing
          system("cmus-remote --pause")
          $logger.info("PAUSE")
        else
          system("cmus-remote --play")
          $logger.info("PLAY")
        end
      end
      private :do_play

      def do_pause
        system("cmus-remote --pause")
        $logger.info("PAUSE")
      end
      private :do_pause

      def do_next
        system("cmus-remote --next")
        $logger.info("NEXT")
      end
      private :do_next

      def do_prev
        system("cmus-remote --prev")
        $logger.info("PREV")
      end
      private :do_prev

      def daemon(info)
        io   = File.open(info[:dev_file], "rb")
        size = [0, 0, 0, 0, 0].pack(EVENT_STRUCTURE).bytesize

        until io.eof?
          raw = io.read(size)
          tmp = raw.unpack(EVENT_STRUCTURE)

          type = tmp[2]
          code = tmp[3]
          val  = tmp[4]

          $logger.debug("push #{type}, #{code}, #{val}")

          next if type != 1 or val != 0

          FUNC_TABLE[code] && send(FUNC_TABLE[code])
        end

      rescue RuntimeError
        $logger.debug("stop daemon")

      ensure
        io&.close
      end
    end
  end
end

