
MAPPING =
  stamina:
    where: '#general + div .table:nth-of-type(2) .row0 .col1'
    type: 'int'

  willpower:
    where: '#general + div .table:nth-of-type(2) .row0 .col3'
    type: 'int'

  strength:
    where: '#general + div .table:nth-of-type(2) .row1 .col1'
    type: 'int'

  perception:
    where: '#general + div .table:nth-of-type(2) .row1 .col3'
    type: 'int'

  agility:
    where: '#general + div .table:nth-of-type(2) .row2 .col1'
    type: 'int'

  intelligence:
    where: '#general + div .table:nth-of-type(2) .row2 .col3'
    type: 'int'

  reflexes:
    where: '#general + div .table:nth-of-type(2) .row3 .col1'
    type: 'int'

  awareness:
    where: '#general + div .table:nth-of-type(2) .row3 .col3'
    type: 'int'

  void:
    where: '#general + div .table:nth-of-type(2) .row4 .col1'
    type: 'int'

  status:
    where: '#general + div .table:nth-of-type(3) .row0 .col1'
    type: 'rank'

  glory:
    where: '#general + div .table:nth-of-type(3) .row0 .col3'
    type: 'rank'

  honor:
    where: '#general + div .table:nth-of-type(3) .row0 .col5'
    type: 'rank'

  taint:
    where: '#general + div .table:nth-of-type(3) .row0 .col7'
    type: 'rank'

  skills:
    where: '#skills + div .table:nth-of-type(1) tr:gt(0)'
    type: 'skills_array'

  earth:
    where: '#general + div .table:nth-of-type(2) .row0 .col5'
    type: 'int'
    compute: 'min(willpower, stamina)'

  water:
    where: '#general + div .table:nth-of-type(2) .row1 .col5'
    type: 'int'
    compute: 'min(perception, strength)'

  fire:
    where: '#general + div .table:nth-of-type(2) .row2 .col5'
    type: 'int'
    compute: 'min(intelligence, agility)'

  air:
    where: '#general + div .table:nth-of-type(2) .row3 .col5'
    type: 'int'
    compute: 'min(awareness, reflexes)'

  insight:
    where: '#general + div .table:nth-of-type(1) .row1 .col1'
    type: 'special'

  'insight rank':
    where: '#general + div .table:nth-of-type(1) .row1 .col3'
    type: 'special'

  'wound level normal':
    where: "#wounds + div .table:nth-of-type(1) .row1 .col1,
            #wounds + div .table:nth-of-type(1) .row2 .col1,
            #wounds + div .table:nth-of-type(1) .row3 .col1,
            #wounds + div .table:nth-of-type(1) .row4 .col1,
            #wounds + div .table:nth-of-type(1) .row5 .col1,
            #wounds + div .table:nth-of-type(1) .row6 .col1,
            #wounds + div .table:nth-of-type(1) .row7 .col1"
    type: 'int'
    compute: 'earth * 2'

  'wound level out':
    where: '#wounds + div .table:nth-of-type(1) .row8 .col1'
    type: 'int'
    compute: 'earth * 5'

  'tn to be hit':
    type: 'int'
    compute: 'reflexes * 5'

  initiative:
    type: 'roll'
    compute: 'reflexes|insight rank'
