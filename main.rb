require 'ffi'

class ULongPtr < FFI::Struct
  layout :value, :ulong
end

class UCharPtr < FFI::Struct
  layout :value, :char
end

class Point < FFI::Struct
  layout :x, :uchar,
         :y, :uchar
end

module PointsLib
  extend FFI::Library

  ffi_lib "zig-out/lib/libpoints.so"

  attach_function :generatePoints, [ULongPtr, UCharPtr], :bool
  attach_function :freePoints, [:ulong, :uchar], :void
end

class Points
  def self.coordinates
    addr_ptr = ULongPtr.new
    len_ptr  = UCharPtr.new

    PointsLib.generatePoints(addr_ptr, len_ptr) or raise("Error in Zig")

    addr, len  = addr_ptr[:value], len_ptr[:value]
    points_ptr = FFI::Pointer.new(Point.size, addr)

    coords = (0...len).map do |i|
      point = Point.new(points_ptr[i])
      [point[:x], point[:y]]
    end

    PointsLib.freePoints addr, len

    coords
  end
end

