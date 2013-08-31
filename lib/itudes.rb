# encoding: utf-8

# @author Alexei Matyushkin

require "itudes/version"

class String
# Monkeypatches {String} class to parse strings representing multitudes.
#   Accepts the following formats:
#   - 53.1234565
#   - 53°11′18″N
#   - 53 11 18N
#
# @param strict [Boolean] the strictness of convertion (the method raises
#   an exception if set to _true_
# @return [Float] the multitude or `nil` if the convertion was not possible.
  def to_itude strict = false
    case self
    when /^(?<val>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)$/ # -53.133333
      $~[:val].to_f
    when /(?<deg>\d+)[°\s]*(?<min>\d*)['’′\s]*(?<sec>\d*)["”″\s]*(?<ss>[NESWnesw]?)$/ # 53°11′18″N, 000°08′00″E
      f = $~[:deg].to_f + $~[:min].to_f / 60.0 + $~[:sec].to_f / 3600.0
      ($~[:ss].to_s.downcase =~ /[sw]/).nil? ? f : -f
    else
      strict ? raise(TypeError.new "no implicit conversion of string “#{self}” to [Lat,Long]itude") : nil
    end
  end
end

module Geo
  # Convenience class to operate w/ multitudes.
  class Itudes
      attr_reader :latitude, :longitude, :units
      # Earth radius in different measurement units (needed to calc distance
      # between two points on the Earth.)
      RADIUS = {
        :km => 6_371, # km
        :mi => 3_959  # mi
      }
      # Constructs the {Geo::Itudes} instance.
      # If there are two parameters, they may be either strings or floats (or
      # string and float.) If there is the only param, it may be one of the 
      # following: 
      #   - {Itudes} — produces a dup copy of it, 
      #   - {String} — tries to parse string (see String#to_itude)
      #   - {Array} — tries to parse elements
      #
      # @param v1 either latitude or one of possible multitudes representations
      # @param v2 longitude (if given)
      # @return [Itudes] the multitudes object
      def initialize v1, v2 = nil
        @latitude, @longitude = (v2.nil? ?
            case v1
              when Itudes  then [v1.latitude, v1.longitude]
              when String then v1.split(',').map(&:to_itude)
              when Array  then v1.map { |m| Itudes.tudify m }
            end :
            [Itudes.tudify(v1), Itudes.tudify(v2)]).map(&:to_f)
        kilometers!
      end
      # Sets the internal measurement to miles (see #distance)
      def miles!
        @units = :mi
        self
      end
      # Sets the internal measurement to kilometers (see #distance)
      def kilometers!
        @units = :km
        self
      end
      # Compares against another instance. 
      # @return [Boolean] _true_ if other value represents the same
      #   multitudes values, _false_ otherwise
      def == other
        other = Itudes.new other
        (@latitude == other.latitude) && (@longitude == other.longitude)
      end
      # String representation of multitudes.
      # @return [String] in the form "53.121231231, -18.43534656"
      def to_s
        "#{@latitude},#{@longitude}"
      end
      # Array representation of multitudes.
      # @return [Array] [@latitude, @longitude]
      def to_a
        [@latitude, @longitude]
      end
      # Calculates the nearest [lat,long] location, basing in the value of
      #   parameter. E. g. for [53.121231231, -18.4353465] will return [53.0, -18.5].
      #   It might be useful if we need to round multitudes to present them.
      # @param slice [Number] the “modulo” to calculate nearest “rounded” value
      # @return [Itudes] the rounded value
      def round slice = 0.5
        Itudes.new @latitude - @latitude.modulo(slice), @longitude - @longitude.modulo(slice)
      end
      # Checks if the multitudes behind represent the correct place on the Earth.
      # @return [Boolean] _true_ if the multitudes are OK 
      def valid?
        !@latitude.nil? && !@longitude.nil? && !(@latitude.zero? && @longitude.zero?) && \
            @latitude > -90 && @latitude < 90 && @longitude > -90 && @longitude < 90
      end
      # Calculates distance between two points on the Earth.
      # @param other the place on the Earth to calculate distance to
      # @return [Float] the distance between two places on the Earth
      def distance other
        o = Itudes.new other
        raise ArgumentError.new "operand must be lat-/longitudable" if (o.latitude.nil? || o.longitude.nil?)

        dlat = Itudes.radians(o.latitude - @latitude)
        dlon = Itudes.radians(o.longitude - @longitude)
        lat1 = Itudes.radians(@latitude)
        lat2 = Itudes.radians(o.latitude);

        a = Math::sin(dlat/2)**2 + Math::sin(dlon/2)**2 * Math::cos(lat1) * Math::cos(lat2)
        (RADIUS[@units] * 2.0 * Math::atan2(Math.sqrt(a), Math.sqrt(1-a))).abs
      end
      alias :- :distance

      # Calculates distance between two points on the Earth. Convenient method.
      def self.distance start, finish
        Itudes.new(start) - Itudes.new(finish)
      end

    private
      def self.tudify val #:nodoc:
        String === val ? val.to_itude : val
      end
      def self.radians degrees #:nodoc:
        Math::PI * degrees / 180
      end
  end
end
