class SupplyFinder
  class Result
    attr_reader :recognized, :unrecognized

    def initialize recognized:, unrecognized:
      @recognized, @unrecognized = recognized, unrecognized
    end
  end

  def initialize medlink:, user:
    @medlink, @user = medlink, user
  end

  def run supplies
    recognized, unrecognized = [], []
    supplies.each do |text|
      if s = lookup(text)
        recognized.push s
      else
        unrecognized.push text
      end
    end

    Result.new recognized: recognized, unrecognized: unrecognized
  end

  def near_match text
    ss = suggestions text, cutoff: 0.7
    ss.first if ss.count == 1
  end

  def suggestions text, cutoff: 0.4, limit: 3
    text = text.strip.downcase
    suggestions = supplies.
      map     { |sup| [sup, d(sup, text)] }.
      select  { |_, d| d >= cutoff }.
      sort_by { |_, d| -d }.
      first(limit).
      map &:first
  end

  def has_match? text
    !!lookup(text)
  end

  private

  attr_reader :medlink, :user

  def lookup text
    text = text.strip.downcase
    supplies_by_shortcode[text] || supplies_by_name[text] || near_match(text)
  end

  def supplies_by_shortcode
    @_supplies_by_shortcode ||= supplies.map { |s| [s.shortcode.downcase, s] }.to_h
  end

  def supplies_by_name
    @_supplies_by_name ||= supplies.map { |s| [s.name.downcase, s] }.to_h
  end

  def supplies
    @_supplies ||= medlink.available_supplies(credentials: user.credentials)
  end

  def d supply, text
    @white ||= Text::WhiteSimilarity.new
    [
      @white.similarity(text, supply.name.downcase),
      @white.similarity(text, supply.shortcode.downcase),
    ].max
  end
end
