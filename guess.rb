require "yaml"

class Guess
  def initialize(path)
    @detail = YAML.load_file(path)
    @detail = rec_symbolize_keys(@detail)
  end

  def extract(type)
    @detail.map do |entry|
      entry[:type] = type
      case entry[:freq]
      when "monthly"
        MonthlyFluctuation.new(entry)
      when "daily"
        DailyFluctuation.new(entry)
      when "once"
        OneOffFluctuation.new(entry)
      end
    end
  end

  def rec_symbolize_keys(node)
    if node.is_a? Hash
      return {}.tap do |new_node|
        node.each do |key, val|
          new_node[key.to_sym] = rec_symbolize_keys(val)
        end
      end
    elsif node.is_a? Array
      return [].tap do |new_node|
       node.each do |val|
         new_node << rec_symbolize_keys(val)
       end
     end
   else
     node
   end
  end
end
