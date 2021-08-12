#!/usr/bin/env ruby

require 'sinatra/base'
require 'sinatra/json'
require 'pg'
require 'parseconfig'

class GeoJsonApi < Sinatra::Base
  
  before do
    @config = ParseConfig.new(File.join(File.dirname(__FILE__), 'settings.conf'))
    @conn = PG.connect( 
      :dbname => @config['dbname'], 
      :user => @config['user'],
      :port => @config['port'],
      :password => @config['password'],
      :host => @config['host']
    )
  end
  
  # `POST` - Accepts GeoJSON point(s) to be inserted into a database table
  #  params: Array of GeoJSON Point objects or Geometry collection
  post '/points' do
    json :placeholder => 'value'
  end
  
  # `GET` - Responds w/GeoJSON point(s) within a radius around a point
  #  params: GeoJSON Point and integer radius in feet/meters
  get '/point/:point/radius/:radius' do
    point = params['point']
    radius = params['radius']
    json :placeholder => 'value'
  end
  
  # `GET` - Responds w/GeoJSON point(s) within a geographical polygon
  # params: GeoJSON Polygon with no holes
  get '/polygon/:polygon' do
    polygon = params['polygon']
    json :placeholder => 'value'
  end 
  
  get '/' do
    @conn.exec( "SELECT * FROM spatial_ref_sys limit 10" ) do |result|
      result.each do |row|
        puts " %7d | %-16s | %d | %s | %s " %
          row.values_at('srid', 'auth_name', 'auth_srid', 'srtext', 'proj4text' )
      end
    end

  "Hello World"
  end

  # Clean up 
  after do
    @conn.finish
  end
  
  run!
end

