class Filter < ActiveRecord::Base
  def self.import
    Dir::glob("tmp/filters/*").each do |f|
      JSON.parse(File.open(f, 'r').read).each do |params|
        filter = self.find_or_create_by(
          id: params['id']
        )
        filter.update!(params)
      end
    end
  end
end
