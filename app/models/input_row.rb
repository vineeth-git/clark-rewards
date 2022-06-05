class InputRow
  attr_accessor(:date, :time, :user, :operation, :recommends)
  def initialize(row)
    splitted_row = row.split(' ')
    self.date = splitted_row[0]
    self.time = splitted_row[1]
    self.user = splitted_row[2]
    self.operation = splitted_row[3]
    self.recommends = splitted_row[4]
  end
end
