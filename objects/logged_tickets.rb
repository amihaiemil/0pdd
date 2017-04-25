# encoding: utf-8
#
# Copyright (c) 2016-2017 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#
# Tickets that are logged.
#
class LoggedTickets
  def initialize(log, tickets)
    @log = log
    @tickets = tickets
  end

  def safe
    @tickets.safe
  end

  def submit(puzzle)
    tag = "#{puzzle.xpath('id').text}/submit"
    raise "Tag \"#{tag}\" already exists, won't submit again. This situation \
most probably means that this puzzle was already seen in the code and \
you're trying to create it again. We would recommend you to re-phrase \
the text of the puzzle and push again. If this doesn't work, pleas let us know \
in GitHub: https://github.com/yegor256/0pdd/issues" if @log.exists(tag)
    done = @tickets.submit(puzzle)
    @log.put(
      tag,
      "#{puzzle.xpath('id').text} submitted in issue ##{done[:number]}"
    )
    done
  end

  def close(puzzle)
    done = @tickets.close(puzzle)
    if done
      tag = "#{puzzle.xpath('id').text}/closed"
      raise "Tag \"#{tag}\" already exists, won't close again. This is \
a rare and rather unusual bug. Please report it to us: \
https://github.com/yegor256/0pdd/issues" if @log.exists(tag)
      @log.put(
        tag,
        "#{puzzle.xpath('id').text} closed in issue \
##{puzzle.xpath('issue').text}"
      )
    end
    done
  end
end
