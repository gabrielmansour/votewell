fs = require 'fs'

provinces =
  AB: 'Alberta'
  BC: 'British Columbia'
  MB: 'Manitoba'
  NB: 'New Brunswick'
  NL: 'Newfoundland and Labrador'
  NS: 'Nova Scotia'
  NT: 'Northwest Territories'
  NU: 'Nunavut'
  ON: 'Ontario'
  PE: 'Prince Edward Island'
  QC: 'Quebec'
  SK: 'Saskatchewan'
  YT: 'Yukon'

polls_regex = ///^
  (?<riding>.+\S)   \s+ # Riding name
  [\w.]+            \s+ # (incumbant)
  (?<lib>\d+)       \s+ # Liberal
  (?<pc>\d+)        \s+ # Conservative
  (?<ndp>\d+)       \s+ # NDP
  (?<bloc>\d+)      \s+ # Bloc
  (?<gpc>\d+)       \s+ # Green
  (?<other>\d+)         # Other
  .*                    # (projection etc)
$///mg


ret = []
for province_code, province of provinces
  polls = fs.readFileSync "#{__dirname}/polls/#{province_code.toLowerCase()}.txt", "utf8"

  while res = polls_regex.exec polls
    { riding, pc, ndp, lib, bloc, gpc, other } = res.groups
    ret.push {
      province_code
      province
      riding
      pc:     parseInt pc
      ndp:    parseInt ndp
      lib:    parseInt lib
      bloc:   parseInt bloc
      gpc:    parseInt gpc
      other:  parseInt other
    }

fs.writeFileSync "#{__dirname}/polls.json", JSON.stringify ret, undefined, 2