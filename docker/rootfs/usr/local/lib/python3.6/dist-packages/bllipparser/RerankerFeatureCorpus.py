# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.  You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.

"""
cvlm corpus read/transform support.

Data structures and utilities to read the format that cvlm (reranker
optimizer) takes as input (sparse feature values associated with each
candidate).

This needs the waterworks utility library.
(https://github.com/dmcc/waterworks)

Example:

>>> corpus = RerankerFeatureCorpus('path/to/filename.gz')
>>> for sentence in corpus:
...     print('index', sentence.index, 'num parses', len(sentence.parses))
...     print('num parse0 features', len(sentence.parses[0].features))

"""
from collections import defaultdict
from waterworks.Strings import try_parse_float, try_parse_int
from waterworks.Files import possibly_compressed_file
from waterworks.Tools import initialize, generic_repr
import PrecRec
from AIMA import argmax_list

def parse_kv_list(text):
    """Parse cvlm key-value pairs from text. Returns a default dictionary
    (missing features will have value 0.0)."""
    pieces = text.split()
    results = defaultdict(float)
    for piece in pieces:
        if '=' in piece:
            key, value = piece.split('=')
            if value.endswith(','):
                value = value[:-1]
            value = try_parse_float(value, value)
        else:
            key = piece
            value = 1
        if key.endswith(','):
            key = key[:-1]
        key = try_parse_int(key, key)
        results[key] = value
    return results

def generate_kv_list(features):
    """Render cvlm key-value pairs to text from a dictionary."""
    pieces = []
    for k, v in sorted(features.items()):
        if v == 1:
            pieces.append(str(k))
        else:
            pieces.append('%s=%s' % (k, v))
    return ' '.join(pieces)

class FeatureMapping(dict):
    """Subclass of dictionary with IO for handling cvlm feature mappings
    and weights.  The mapping is stored as

    { feature index : feature name/weight }"""
    def write(self, filename):
        f = possibly_compressed_file(filename, 'w')
        for index in range(len(self)):
            name = self[index]
            f.write('%d\t%s\n' % (index, name))
        f.close()

    @classmethod
    def weights_from_filename(this_class, filename):
        """Reads cvlm weight vectors from a filename. The expected format
        is that each line has an index followed by an equals sign followed
        by the feature weight (a float). Returns a FeatureMapping."""
        weights = this_class()
        for line in possibly_compressed_file(filename):
            index, weight = line.split('=')
            index = int(index)
            weight = float(weight)
            weights[index] = weight
        return weights

    @classmethod
    def mapping_from_filename(this_class, filename):
        """Reads cvlm feature mapping from a filename. The expected
        format is that each line has an index followed by a tab followed
        by the feature name. Returns a FeatureMapping."""
        mapping = this_class()
        for line in possibly_compressed_file(filename):
            index, name = line.split('\t')
            index = int(index)
            mapping[index] = name.strip()
        return mapping

class RerankerParse:
    """A single parse of a RerankerSentence. Each parse includes
    the number of proposed and matched brackets (which, combined with
    gold_brackets will tell you its f-score) and a sparse feature vector
    (dictionary of features to values)."""
    def __init__(self, proposed_brackets, matched_brackets, features):
        features = defaultdict(int, features)
        initialize(self, locals())
    __repr__ = generic_repr
    def nonzero_features(self):
        """Returns a set of feature names with non-zero values."""
        return set(feature for (feature, value) in self.features.items()
                   if value != 0)
    def subtract_features(self, other_parse):
        """Shifts all feature values by those in another RerankerParse.
        As a result, shifting a RerankerParse by itself will set all of
        its features to zero."""
        if self == other_parse:
            self.features.clear()
        else:
            for index, value in other_parse.features.items():
                self.features[index] -= value
    def map_and_prune(self, mapping):
        """Remaps the feature names according to a mapping:
            { old feature name : new feature name }
        If the new feature name is None, the feature will be pruned. The
        mapping must completely cover the features in this parse (that
        is, each feature name for this parse must have an entry in the
        mapping). This is to help ensure that your mapping is compatible
        with features on this parse."""
        mapped_features = {}
        for old_name, value in self.features.items():
            new_name = mapping[old_name]
            if new_name is not None and value != 0:
                mapped_features[new_name] = value
        self.features = mapped_features
    def score(self, weights):
        """Score this parse using a weight vector (dictionary of feature
        names to weights)."""
        total_score = 0
        for feature, value in self.features.items():
            weight = weights[feature]
            total_score += weight * value
        return total_score
    def cvlm_format(self):
        """Render this parse in cvlm's sparse feature vector format."""
        meta = 'P=%s W=%s' % (self.proposed_brackets, self.matched_brackets)
        if self.features:
            return '%s %s' % (meta, generate_kv_list(self.features))
        else:
            return meta

class RerankerSentence:
    """A single sentence for input to cvlm. Each sentence includes the
    number of gold brackets, its index in the corpus, and a list of
    all candidate parses with their features and evaluation information
    (RerankerParse objects).

    Each RerankerParse has "winner" parses (parses with the highest
    f-score in the sentence -- there can be ties) and "loser" parses
    (all other parses)."""
    def __init__(self, gold_brackets, parses, index):
        initialize(self, locals())
    __repr__ = generic_repr
    def __iter__(self):
        """Iterate over all the RerankerParse objects in this sentence."""
        return iter(self.parses)
    def __len__(self):
        """Returns the number of RerankerParse objects in this sentence."""
        return len(self.parses)
    def __getitem__(self, index):
        """Retrieves a RerankerParse object in this sentence by its index."""
        return self.parses[index]
    def relativize_feature_values(self, relative_index=0):
        """Make features in all the RerankerParse objects relative by
        shifting all feature values by those in the top parse (you can
        pick a different parse by setting the relative_index flag). This
        will set all features in the top parse to zero and potentially
        simplify the features of the remaining parses (assuming their
        features look mostly like those in the top parse -- in some cases,
        this can increase the number of non-zero features)."""
        if not self.parses:
            return
        rel_parse = self.parses[relative_index]
        for parse in self.parses:
            if parse == rel_parse:
                continue
            parse.subtract_features(rel_parse)
        rel_parse.subtract_features(rel_parse)
    def fscore_components(self, parse):
        """Returns the f-score components (matched, gold, proposed)
        of a RerankerParse in this sentence."""
        return (parse.matched_brackets, self.gold_brackets,
                parse.proposed_brackets)
    def fscore(self, parse):
        """Returns the f-score of a RerankerParse in this sentence."""
        components = self.fscore_components(parse)
        return PrecRec.fscore_from_components(*components)
    def winner_parses(self):
        """Returns a list of the "winner" parses."""
        return argmax_list(self.parses, self.fscore)
    def oracle_fscore(self):
        """Returns the highest f-score from one of the candidate parses
        (all winner parses will have this f-score)."""
        return max(self.fscore(parse) for parse in self.parses)
    def distinguishing_feature_counts(self):
        """Returns a dictionary mapping feature indices to the number
        of times they distinguished a "winner" from "loser" parses."""
        feature_counts = defaultdict(int)
        winners = self.winner_parses()

        all_features = set()
        for parse in self:
            all_features.update(parse.features.keys())

        if len(winners) == len(self.parses):
            # no losers means nothing is distinguishing.
            # to build a complete mapping, we still store the counts of the
            # features as 0s.
            for feature in all_features:
                feature_counts[feature] = 0
            return feature_counts

        losers = [parse for parse in self.parses if parse not in winners]
        all_winner_features = set()
        nonzero_features = set()
        # find all values of features for any winner parses
        for winner in winners:
            all_winner_features.update(winner.features.items())
            nonzero_features.update(winner.nonzero_features())
        # now find features of any loser parse with a different value
        # (unless they only show up with 0 as their value -- these
        # aren't really distinguishing, but could appear as such if they're
        # unspecified in the winner parses and explicitly set to 0 in the
        # lower parses)
        all_loser_features = set()
        for loser in losers:
            all_loser_features.update(loser.features.items())
            nonzero_features.update(loser.nonzero_features())

        diffs = all_loser_features.symmetric_difference(all_winner_features)
        distinguishing_features = set(feature for (feature, value) in diffs)
        for feature in all_features:
            if feature in distinguishing_features and \
               feature in nonzero_features:
                feature_counts[feature] += 1
            else:
                feature_counts[feature] = 0
        return feature_counts
    def map_and_prune(self, mapping):
        """Applies RerankerParse.map_and_prune() to every parse in
        this sentence."""
        for parse in self.parses:
            parse.map_and_prune(mapping)
    def rerank(self, weights):
        """Score all parses and sort them by their scores using a weight
        vector (dictionary of feature names to weights). Note that this
        modifies the list of parses in place."""
        self.parses.sort(key=lambda parse: parse.score(weights),
                         reverse=True)
    def cvlm_format(self):
        """Render this sentence in cvlm's sparse feature vector format."""
        return 'G=%s N=%s %s,' % (self.gold_brackets, len(self.parses),
                                  ', '.join(parse.cvlm_format()
                                            for parse in self.parses))

    @classmethod
    def from_string(this_class, text, index):
        parses_text = text.split(', ')
        gold_brackets = None
        parses = []
        for parse_index, parse_text in enumerate(parses_text):
            features = parse_kv_list(parse_text)
            if parse_index == 0:
                gold_brackets = features.pop('G')
                features.pop('N')
            proposed_brackets = features.pop('P')
            matched_brackets = features.pop('W')

            parses.append(RerankerParse(proposed_brackets, matched_brackets,
                                        features))
        assert gold_brackets is not None
        return this_class(gold_brackets, parses, index)

class RerankerFeatureCorpus:
    """Made up of a series of sentences. Because these files are huge
    and the Python wrappers around these structures cannot typically be
    stored in memory, this only lets you iterate over the corpus. Note
    that if you're generating a new reranker input file for cvlm,
    you'll need to write the result from cvlm_format_header() followed
    by the cvlm_format() for each sentence in the corpus.  The number
    of sentences in the RerankerFeatureCorpus corpus is available as
    its length."""
    def __init__(self, filename):
        initialize(self, locals())

        self.reader = iter(possibly_compressed_file(filename))
        self.header = parse_kv_list(next(self.reader))
        assert 'S' in self.header
        self.num_sentences = self.header['S']

    __repr__ = generic_repr

    def cvlm_format_header(self):
        """Return the header in cvlm format."""
        return 'S=%d\n' % self.num_sentences

    def __len__(self):
        """Returns the number of sentences in this corpus."""
        return self.num_sentences

    def __iter__(self):
        """Returns an iterator over each sentence in the corpus."""
        for i, line in enumerate(self.reader):
            sentence = RerankerSentence.from_string(line, i)
            sentence.header = self.header
            yield sentence

    def transform(self, transformer):
        """Iterate over every sentence in this corpus, applying a
        transformation function to each. The transformer will be called
        on each RerankerSentence instance in order."""
        for sentence in self:
            yield transformer(sentence)
