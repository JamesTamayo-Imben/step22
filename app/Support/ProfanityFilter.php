<?php

namespace App\Support;

class ProfanityFilter
{
    /**
     * Filipino profanity list from jromest/filipino-badwords-list (MIT).
     */
    private const WORDS = [
        'amputa', 'animal ka', 'bilat', 'binibrocha', 'bobo', 'bogo', 'boto', 'brocha',
        'burat', 'bwesit', 'bwisit', 'demonyo ka', 'engot', 'etits', 'gaga', 'gagi',
        'gago', 'habal', 'hayop ka', 'hayup', 'hinampak', 'hinayupak', 'hindot', 'hindutan',
        'hudas', 'iniyot', 'inutel', 'inutil', 'iyot', 'kagaguhan', 'kagang', 'kantot',
        'kantotan', 'kantut', 'kantutan', 'kaululan', 'kayat', 'kiki', 'kikinginamo',
        'kingina', 'kupal', 'leche', 'leching', 'lechugas', 'lintik', 'nakakaburat',
        'nimal', 'ogag', 'olok', 'pakingshet', 'pakshet', 'pakyu', 'pesteng yawa', 'poke',
        'poki', 'pokpok', 'poyet', "pu'keng", 'pucha', 'puchanggala', 'puchangina',
        'puke', 'puki', 'pukinangina', 'puking', 'punyeta', 'puta', 'putang', 'putang ina',
        'putangina', 'putanginamo', 'putaragis', 'putragis', 'puyet', 'ratbu', 'shunga',
        'sira ulo', 'siraulo', 'suso', 'susu', 'tae', 'taena', 'tamod', 'tanga', 'tangina',
        'taragis', 'tarantado', 'tete', 'teti', 'timang', 'tinil', 'tite', 'titi', 'tungaw',
        'ulol', 'ulul', 'ungas', 'uwak', 'yawa', 'yawa ka', 'yawa mo', 'yawa mo ah', 'yawa mo ahh', 'yawa mo ahhh',
        'fck', 'fcking', 'fckin', 'fckn', 'fckng', 'fcknig', 'fcknigah', 'fcknigahh', 'fcknigahhh', 'fcknigahhhh', 'fcknigahhhhhh', 'fcknigahhhhh', 
        'fcknig', 'nigga', 'nigga', 'niggah', 'niggahh', 'nigg', 'bitch', 'btch',
        'masimot', 'ayupan', 'kapay', 'lintian', 'simton', 'laputa', 'lamama', 'lapapa', 'buryani ina',
        'kiffy', 'qpal', 'kupal', 'kipay',
    ];

    public static function contains(?string $value): bool
    {
        if ($value === null || trim($value) === '') {
            return false;
        }

        $normalizedValue = self::normalize($value);

        foreach (self::WORDS as $word) {
            $normalizedWord = self::normalize($word);

            if (str_contains(" {$normalizedValue} ", " {$normalizedWord} ")) {
                return true;
            }
        }

        return false;
    }

    private static function normalize(string $value): string
    {
        $value = mb_strtolower($value, 'UTF-8');
        $value = preg_replace('/[^\p{L}\p{N}]+/u', ' ', $value) ?? $value;

        return trim(preg_replace('/\s+/u', ' ', $value) ?? $value);
    }
}
