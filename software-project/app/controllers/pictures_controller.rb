class PicturesController < ApplicationController
    # GET /pictures/new
    def new
      @picture = Picture.new
    end
end
  