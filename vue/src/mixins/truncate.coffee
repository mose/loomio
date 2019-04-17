import _truncate from 'lodash/truncate'
export default
  methods:
    truncate: (string, length = 100, separator = ' ') ->
      _truncate string, length: length, separator: separator
