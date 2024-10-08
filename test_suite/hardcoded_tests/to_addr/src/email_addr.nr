global table = comptime { make_lookup_table() };
pub fn regex_match<let N: u32>(input: [u8; N]) -> (Vec<BoundedVec<Field, N>>, bool) {
    // regex: [A-Za-z0-9!#$%&'*+=?\-\^_`{|}~./@]+@[A-Za-z0-9.\-]+
    let mut substrings: Vec<BoundedVec<Field, N>> = Vec::new();

    // "Previous" state
    let mut s: Field = 0;
    s = table[255];
    // "Next"/upcoming state
    let mut s_next: Field = 0;

    let mut consecutive_substr = 0;
    let mut current_substring = BoundedVec::new();

    for i in 0..input.len() {
        let temp = input[i] as Field;
        let mut reset = false;
        s_next = table[s * 256 + temp];
        if s_next == 0 {
            // Check if there is any transition that could be done from a "restart"
            s_next = table[temp];
            // whether the next state changes or not, we mark this as a reset.
            reset = true;
            s = 0;
        }

        // If a substring was in the making, but the state was reset
        // we disregard previous progress because apparently it is invalid
        if (reset & (consecutive_substr == 1)) {
            current_substring = BoundedVec::new();
            consecutive_substr = 0;
        }
        // Fill up substrings
        if ((s == 0) & (s_next == 1)
            | (s == 1) & (s_next == 1)
            | (s == 1) & (s_next == 2)
            | (s == 2) & (s_next == 1)
            | (s == 2) & (s_next == 2)
            | (s == 2) & (s_next == 3)
            | (s == 3) & (s_next == 1)
            | (s == 3) & (s_next == 2)
            | (s == 3) & (s_next == 3)) {
            if (consecutive_substr == 0) {
                current_substring.push(temp);
                consecutive_substr = 1;
            } else if (consecutive_substr == 1) {
                current_substring.push(temp);
            }
        } else if ((consecutive_substr == 1) & (s_next == 0)) {
            current_substring = BoundedVec::new();
            consecutive_substr = 0;
        } else if (consecutive_substr == 1) {
            // The substring is done so "save" it
            substrings.push(current_substring);
            // reset the substring holder for next use
            current_substring = BoundedVec::new();
            consecutive_substr = 0;
        }
        s = s_next;
    }
    // Instead of doing the direct assert, return boolean whether this regex matches or not
    // assert((s == 3) | (s == 4), f"no match: {s}");
    // Add pending substring that hasn't been added
    if consecutive_substr == 1 {
        substrings.push(current_substring);
    }
    (substrings, (s == 3) | (s == 4))
}

comptime fn make_lookup_table() -> [Field; 1280] {
    let mut table = [0; 1280];
    table[3 * 256 + 0] = 4;
    table[4 * 256 + 0] = 4;
    table[3 * 256 + 1] = 4;
    table[4 * 256 + 1] = 4;
    table[3 * 256 + 2] = 4;
    table[4 * 256 + 2] = 4;
    table[3 * 256 + 3] = 4;
    table[4 * 256 + 3] = 4;
    table[3 * 256 + 4] = 4;
    table[4 * 256 + 4] = 4;
    table[3 * 256 + 5] = 4;
    table[4 * 256 + 5] = 4;
    table[3 * 256 + 6] = 4;
    table[4 * 256 + 6] = 4;
    table[3 * 256 + 7] = 4;
    table[4 * 256 + 7] = 4;
    table[3 * 256 + 8] = 4;
    table[4 * 256 + 8] = 4;
    table[3 * 256 + 9] = 4;
    table[4 * 256 + 9] = 4;
    table[3 * 256 + 10] = 4;
    table[4 * 256 + 10] = 4;
    table[3 * 256 + 11] = 4;
    table[4 * 256 + 11] = 4;
    table[3 * 256 + 12] = 4;
    table[4 * 256 + 12] = 4;
    table[3 * 256 + 13] = 4;
    table[4 * 256 + 13] = 4;
    table[3 * 256 + 14] = 4;
    table[4 * 256 + 14] = 4;
    table[3 * 256 + 15] = 4;
    table[4 * 256 + 15] = 4;
    table[3 * 256 + 16] = 4;
    table[4 * 256 + 16] = 4;
    table[3 * 256 + 17] = 4;
    table[4 * 256 + 17] = 4;
    table[3 * 256 + 18] = 4;
    table[4 * 256 + 18] = 4;
    table[3 * 256 + 19] = 4;
    table[4 * 256 + 19] = 4;
    table[3 * 256 + 20] = 4;
    table[4 * 256 + 20] = 4;
    table[3 * 256 + 21] = 4;
    table[4 * 256 + 21] = 4;
    table[3 * 256 + 22] = 4;
    table[4 * 256 + 22] = 4;
    table[3 * 256 + 23] = 4;
    table[4 * 256 + 23] = 4;
    table[3 * 256 + 24] = 4;
    table[4 * 256 + 24] = 4;
    table[3 * 256 + 25] = 4;
    table[4 * 256 + 25] = 4;
    table[3 * 256 + 26] = 4;
    table[4 * 256 + 26] = 4;
    table[3 * 256 + 27] = 4;
    table[4 * 256 + 27] = 4;
    table[3 * 256 + 28] = 4;
    table[4 * 256 + 28] = 4;
    table[3 * 256 + 29] = 4;
    table[4 * 256 + 29] = 4;
    table[3 * 256 + 30] = 4;
    table[4 * 256 + 30] = 4;
    table[3 * 256 + 31] = 4;
    table[4 * 256 + 31] = 4;
    table[3 * 256 + 32] = 4;
    table[4 * 256 + 32] = 4;
    table[3 * 256 + 33] = 4;
    table[4 * 256 + 33] = 4;
    table[3 * 256 + 34] = 4;
    table[4 * 256 + 34] = 4;
    table[3 * 256 + 35] = 4;
    table[4 * 256 + 35] = 4;
    table[3 * 256 + 36] = 4;
    table[4 * 256 + 36] = 4;
    table[3 * 256 + 37] = 4;
    table[4 * 256 + 37] = 4;
    table[3 * 256 + 38] = 4;
    table[4 * 256 + 38] = 4;
    table[3 * 256 + 39] = 4;
    table[4 * 256 + 39] = 4;
    table[3 * 256 + 40] = 4;
    table[4 * 256 + 40] = 4;
    table[3 * 256 + 41] = 4;
    table[4 * 256 + 41] = 4;
    table[3 * 256 + 42] = 4;
    table[4 * 256 + 42] = 4;
    table[3 * 256 + 43] = 4;
    table[4 * 256 + 43] = 4;
    table[3 * 256 + 44] = 4;
    table[4 * 256 + 44] = 4;
    table[3 * 256 + 45] = 4;
    table[4 * 256 + 45] = 4;
    table[3 * 256 + 46] = 4;
    table[4 * 256 + 46] = 4;
    table[3 * 256 + 47] = 4;
    table[4 * 256 + 47] = 4;
    table[3 * 256 + 48] = 4;
    table[4 * 256 + 48] = 4;
    table[3 * 256 + 49] = 4;
    table[4 * 256 + 49] = 4;
    table[3 * 256 + 50] = 4;
    table[4 * 256 + 50] = 4;
    table[3 * 256 + 51] = 4;
    table[4 * 256 + 51] = 4;
    table[3 * 256 + 52] = 4;
    table[4 * 256 + 52] = 4;
    table[3 * 256 + 53] = 4;
    table[4 * 256 + 53] = 4;
    table[3 * 256 + 54] = 4;
    table[4 * 256 + 54] = 4;
    table[3 * 256 + 55] = 4;
    table[4 * 256 + 55] = 4;
    table[3 * 256 + 56] = 4;
    table[4 * 256 + 56] = 4;
    table[3 * 256 + 57] = 4;
    table[4 * 256 + 57] = 4;
    table[3 * 256 + 58] = 4;
    table[4 * 256 + 58] = 4;
    table[3 * 256 + 59] = 4;
    table[4 * 256 + 59] = 4;
    table[3 * 256 + 60] = 4;
    table[4 * 256 + 60] = 4;
    table[3 * 256 + 61] = 4;
    table[4 * 256 + 61] = 4;
    table[3 * 256 + 62] = 4;
    table[4 * 256 + 62] = 4;
    table[3 * 256 + 63] = 4;
    table[4 * 256 + 63] = 4;
    table[3 * 256 + 64] = 4;
    table[4 * 256 + 64] = 4;
    table[3 * 256 + 65] = 4;
    table[4 * 256 + 65] = 4;
    table[3 * 256 + 66] = 4;
    table[4 * 256 + 66] = 4;
    table[3 * 256 + 67] = 4;
    table[4 * 256 + 67] = 4;
    table[3 * 256 + 68] = 4;
    table[4 * 256 + 68] = 4;
    table[3 * 256 + 69] = 4;
    table[4 * 256 + 69] = 4;
    table[3 * 256 + 70] = 4;
    table[4 * 256 + 70] = 4;
    table[3 * 256 + 71] = 4;
    table[4 * 256 + 71] = 4;
    table[3 * 256 + 72] = 4;
    table[4 * 256 + 72] = 4;
    table[3 * 256 + 73] = 4;
    table[4 * 256 + 73] = 4;
    table[3 * 256 + 74] = 4;
    table[4 * 256 + 74] = 4;
    table[3 * 256 + 75] = 4;
    table[4 * 256 + 75] = 4;
    table[3 * 256 + 76] = 4;
    table[4 * 256 + 76] = 4;
    table[3 * 256 + 77] = 4;
    table[4 * 256 + 77] = 4;
    table[3 * 256 + 78] = 4;
    table[4 * 256 + 78] = 4;
    table[3 * 256 + 79] = 4;
    table[4 * 256 + 79] = 4;
    table[3 * 256 + 80] = 4;
    table[4 * 256 + 80] = 4;
    table[3 * 256 + 81] = 4;
    table[4 * 256 + 81] = 4;
    table[3 * 256 + 82] = 4;
    table[4 * 256 + 82] = 4;
    table[3 * 256 + 83] = 4;
    table[4 * 256 + 83] = 4;
    table[3 * 256 + 84] = 4;
    table[4 * 256 + 84] = 4;
    table[3 * 256 + 85] = 4;
    table[4 * 256 + 85] = 4;
    table[3 * 256 + 86] = 4;
    table[4 * 256 + 86] = 4;
    table[3 * 256 + 87] = 4;
    table[4 * 256 + 87] = 4;
    table[3 * 256 + 88] = 4;
    table[4 * 256 + 88] = 4;
    table[3 * 256 + 89] = 4;
    table[4 * 256 + 89] = 4;
    table[3 * 256 + 90] = 4;
    table[4 * 256 + 90] = 4;
    table[3 * 256 + 91] = 4;
    table[4 * 256 + 91] = 4;
    table[3 * 256 + 92] = 4;
    table[4 * 256 + 92] = 4;
    table[3 * 256 + 93] = 4;
    table[4 * 256 + 93] = 4;
    table[3 * 256 + 94] = 4;
    table[4 * 256 + 94] = 4;
    table[3 * 256 + 95] = 4;
    table[4 * 256 + 95] = 4;
    table[3 * 256 + 96] = 4;
    table[4 * 256 + 96] = 4;
    table[3 * 256 + 97] = 4;
    table[4 * 256 + 97] = 4;
    table[3 * 256 + 98] = 4;
    table[4 * 256 + 98] = 4;
    table[3 * 256 + 99] = 4;
    table[4 * 256 + 99] = 4;
    table[3 * 256 + 100] = 4;
    table[4 * 256 + 100] = 4;
    table[3 * 256 + 101] = 4;
    table[4 * 256 + 101] = 4;
    table[3 * 256 + 102] = 4;
    table[4 * 256 + 102] = 4;
    table[3 * 256 + 103] = 4;
    table[4 * 256 + 103] = 4;
    table[3 * 256 + 104] = 4;
    table[4 * 256 + 104] = 4;
    table[3 * 256 + 105] = 4;
    table[4 * 256 + 105] = 4;
    table[3 * 256 + 106] = 4;
    table[4 * 256 + 106] = 4;
    table[3 * 256 + 107] = 4;
    table[4 * 256 + 107] = 4;
    table[3 * 256 + 108] = 4;
    table[4 * 256 + 108] = 4;
    table[3 * 256 + 109] = 4;
    table[4 * 256 + 109] = 4;
    table[3 * 256 + 110] = 4;
    table[4 * 256 + 110] = 4;
    table[3 * 256 + 111] = 4;
    table[4 * 256 + 111] = 4;
    table[3 * 256 + 112] = 4;
    table[4 * 256 + 112] = 4;
    table[3 * 256 + 113] = 4;
    table[4 * 256 + 113] = 4;
    table[3 * 256 + 114] = 4;
    table[4 * 256 + 114] = 4;
    table[3 * 256 + 115] = 4;
    table[4 * 256 + 115] = 4;
    table[3 * 256 + 116] = 4;
    table[4 * 256 + 116] = 4;
    table[3 * 256 + 117] = 4;
    table[4 * 256 + 117] = 4;
    table[3 * 256 + 118] = 4;
    table[4 * 256 + 118] = 4;
    table[3 * 256 + 119] = 4;
    table[4 * 256 + 119] = 4;
    table[3 * 256 + 120] = 4;
    table[4 * 256 + 120] = 4;
    table[3 * 256 + 121] = 4;
    table[4 * 256 + 121] = 4;
    table[3 * 256 + 122] = 4;
    table[4 * 256 + 122] = 4;
    table[3 * 256 + 123] = 4;
    table[4 * 256 + 123] = 4;
    table[3 * 256 + 124] = 4;
    table[4 * 256 + 124] = 4;
    table[3 * 256 + 125] = 4;
    table[4 * 256 + 125] = 4;
    table[3 * 256 + 126] = 4;
    table[4 * 256 + 126] = 4;
    table[3 * 256 + 127] = 4;
    table[4 * 256 + 127] = 4;
    table[3 * 256 + 128] = 4;
    table[4 * 256 + 128] = 4;
    table[3 * 256 + 129] = 4;
    table[4 * 256 + 129] = 4;
    table[3 * 256 + 130] = 4;
    table[4 * 256 + 130] = 4;
    table[3 * 256 + 131] = 4;
    table[4 * 256 + 131] = 4;
    table[3 * 256 + 132] = 4;
    table[4 * 256 + 132] = 4;
    table[3 * 256 + 133] = 4;
    table[4 * 256 + 133] = 4;
    table[3 * 256 + 134] = 4;
    table[4 * 256 + 134] = 4;
    table[3 * 256 + 135] = 4;
    table[4 * 256 + 135] = 4;
    table[3 * 256 + 136] = 4;
    table[4 * 256 + 136] = 4;
    table[3 * 256 + 137] = 4;
    table[4 * 256 + 137] = 4;
    table[3 * 256 + 138] = 4;
    table[4 * 256 + 138] = 4;
    table[3 * 256 + 139] = 4;
    table[4 * 256 + 139] = 4;
    table[3 * 256 + 140] = 4;
    table[4 * 256 + 140] = 4;
    table[3 * 256 + 141] = 4;
    table[4 * 256 + 141] = 4;
    table[3 * 256 + 142] = 4;
    table[4 * 256 + 142] = 4;
    table[3 * 256 + 143] = 4;
    table[4 * 256 + 143] = 4;
    table[3 * 256 + 144] = 4;
    table[4 * 256 + 144] = 4;
    table[3 * 256 + 145] = 4;
    table[4 * 256 + 145] = 4;
    table[3 * 256 + 146] = 4;
    table[4 * 256 + 146] = 4;
    table[3 * 256 + 147] = 4;
    table[4 * 256 + 147] = 4;
    table[3 * 256 + 148] = 4;
    table[4 * 256 + 148] = 4;
    table[3 * 256 + 149] = 4;
    table[4 * 256 + 149] = 4;
    table[3 * 256 + 150] = 4;
    table[4 * 256 + 150] = 4;
    table[3 * 256 + 151] = 4;
    table[4 * 256 + 151] = 4;
    table[3 * 256 + 152] = 4;
    table[4 * 256 + 152] = 4;
    table[3 * 256 + 153] = 4;
    table[4 * 256 + 153] = 4;
    table[3 * 256 + 154] = 4;
    table[4 * 256 + 154] = 4;
    table[3 * 256 + 155] = 4;
    table[4 * 256 + 155] = 4;
    table[3 * 256 + 156] = 4;
    table[4 * 256 + 156] = 4;
    table[3 * 256 + 157] = 4;
    table[4 * 256 + 157] = 4;
    table[3 * 256 + 158] = 4;
    table[4 * 256 + 158] = 4;
    table[3 * 256 + 159] = 4;
    table[4 * 256 + 159] = 4;
    table[3 * 256 + 160] = 4;
    table[4 * 256 + 160] = 4;
    table[3 * 256 + 161] = 4;
    table[4 * 256 + 161] = 4;
    table[3 * 256 + 162] = 4;
    table[4 * 256 + 162] = 4;
    table[3 * 256 + 163] = 4;
    table[4 * 256 + 163] = 4;
    table[3 * 256 + 164] = 4;
    table[4 * 256 + 164] = 4;
    table[3 * 256 + 165] = 4;
    table[4 * 256 + 165] = 4;
    table[3 * 256 + 166] = 4;
    table[4 * 256 + 166] = 4;
    table[3 * 256 + 167] = 4;
    table[4 * 256 + 167] = 4;
    table[3 * 256 + 168] = 4;
    table[4 * 256 + 168] = 4;
    table[3 * 256 + 169] = 4;
    table[4 * 256 + 169] = 4;
    table[3 * 256 + 170] = 4;
    table[4 * 256 + 170] = 4;
    table[3 * 256 + 171] = 4;
    table[4 * 256 + 171] = 4;
    table[3 * 256 + 172] = 4;
    table[4 * 256 + 172] = 4;
    table[3 * 256 + 173] = 4;
    table[4 * 256 + 173] = 4;
    table[3 * 256 + 174] = 4;
    table[4 * 256 + 174] = 4;
    table[3 * 256 + 175] = 4;
    table[4 * 256 + 175] = 4;
    table[3 * 256 + 176] = 4;
    table[4 * 256 + 176] = 4;
    table[3 * 256 + 177] = 4;
    table[4 * 256 + 177] = 4;
    table[3 * 256 + 178] = 4;
    table[4 * 256 + 178] = 4;
    table[3 * 256 + 179] = 4;
    table[4 * 256 + 179] = 4;
    table[3 * 256 + 180] = 4;
    table[4 * 256 + 180] = 4;
    table[3 * 256 + 181] = 4;
    table[4 * 256 + 181] = 4;
    table[3 * 256 + 182] = 4;
    table[4 * 256 + 182] = 4;
    table[3 * 256 + 183] = 4;
    table[4 * 256 + 183] = 4;
    table[3 * 256 + 184] = 4;
    table[4 * 256 + 184] = 4;
    table[3 * 256 + 185] = 4;
    table[4 * 256 + 185] = 4;
    table[3 * 256 + 186] = 4;
    table[4 * 256 + 186] = 4;
    table[3 * 256 + 187] = 4;
    table[4 * 256 + 187] = 4;
    table[3 * 256 + 188] = 4;
    table[4 * 256 + 188] = 4;
    table[3 * 256 + 189] = 4;
    table[4 * 256 + 189] = 4;
    table[3 * 256 + 190] = 4;
    table[4 * 256 + 190] = 4;
    table[3 * 256 + 191] = 4;
    table[4 * 256 + 191] = 4;
    table[3 * 256 + 192] = 4;
    table[4 * 256 + 192] = 4;
    table[3 * 256 + 193] = 4;
    table[4 * 256 + 193] = 4;
    table[3 * 256 + 194] = 4;
    table[4 * 256 + 194] = 4;
    table[3 * 256 + 195] = 4;
    table[4 * 256 + 195] = 4;
    table[3 * 256 + 196] = 4;
    table[4 * 256 + 196] = 4;
    table[3 * 256 + 197] = 4;
    table[4 * 256 + 197] = 4;
    table[3 * 256 + 198] = 4;
    table[4 * 256 + 198] = 4;
    table[3 * 256 + 199] = 4;
    table[4 * 256 + 199] = 4;
    table[3 * 256 + 200] = 4;
    table[4 * 256 + 200] = 4;
    table[3 * 256 + 201] = 4;
    table[4 * 256 + 201] = 4;
    table[3 * 256 + 202] = 4;
    table[4 * 256 + 202] = 4;
    table[3 * 256 + 203] = 4;
    table[4 * 256 + 203] = 4;
    table[3 * 256 + 204] = 4;
    table[4 * 256 + 204] = 4;
    table[3 * 256 + 205] = 4;
    table[4 * 256 + 205] = 4;
    table[3 * 256 + 206] = 4;
    table[4 * 256 + 206] = 4;
    table[3 * 256 + 207] = 4;
    table[4 * 256 + 207] = 4;
    table[3 * 256 + 208] = 4;
    table[4 * 256 + 208] = 4;
    table[3 * 256 + 209] = 4;
    table[4 * 256 + 209] = 4;
    table[3 * 256 + 210] = 4;
    table[4 * 256 + 210] = 4;
    table[3 * 256 + 211] = 4;
    table[4 * 256 + 211] = 4;
    table[3 * 256 + 212] = 4;
    table[4 * 256 + 212] = 4;
    table[3 * 256 + 213] = 4;
    table[4 * 256 + 213] = 4;
    table[3 * 256 + 214] = 4;
    table[4 * 256 + 214] = 4;
    table[3 * 256 + 215] = 4;
    table[4 * 256 + 215] = 4;
    table[3 * 256 + 216] = 4;
    table[4 * 256 + 216] = 4;
    table[3 * 256 + 217] = 4;
    table[4 * 256 + 217] = 4;
    table[3 * 256 + 218] = 4;
    table[4 * 256 + 218] = 4;
    table[3 * 256 + 219] = 4;
    table[4 * 256 + 219] = 4;
    table[3 * 256 + 220] = 4;
    table[4 * 256 + 220] = 4;
    table[3 * 256 + 221] = 4;
    table[4 * 256 + 221] = 4;
    table[3 * 256 + 222] = 4;
    table[4 * 256 + 222] = 4;
    table[3 * 256 + 223] = 4;
    table[4 * 256 + 223] = 4;
    table[3 * 256 + 224] = 4;
    table[4 * 256 + 224] = 4;
    table[3 * 256 + 225] = 4;
    table[4 * 256 + 225] = 4;
    table[3 * 256 + 226] = 4;
    table[4 * 256 + 226] = 4;
    table[3 * 256 + 227] = 4;
    table[4 * 256 + 227] = 4;
    table[3 * 256 + 228] = 4;
    table[4 * 256 + 228] = 4;
    table[3 * 256 + 229] = 4;
    table[4 * 256 + 229] = 4;
    table[3 * 256 + 230] = 4;
    table[4 * 256 + 230] = 4;
    table[3 * 256 + 231] = 4;
    table[4 * 256 + 231] = 4;
    table[3 * 256 + 232] = 4;
    table[4 * 256 + 232] = 4;
    table[3 * 256 + 233] = 4;
    table[4 * 256 + 233] = 4;
    table[3 * 256 + 234] = 4;
    table[4 * 256 + 234] = 4;
    table[3 * 256 + 235] = 4;
    table[4 * 256 + 235] = 4;
    table[3 * 256 + 236] = 4;
    table[4 * 256 + 236] = 4;
    table[3 * 256 + 237] = 4;
    table[4 * 256 + 237] = 4;
    table[3 * 256 + 238] = 4;
    table[4 * 256 + 238] = 4;
    table[3 * 256 + 239] = 4;
    table[4 * 256 + 239] = 4;
    table[3 * 256 + 240] = 4;
    table[4 * 256 + 240] = 4;
    table[3 * 256 + 241] = 4;
    table[4 * 256 + 241] = 4;
    table[3 * 256 + 242] = 4;
    table[4 * 256 + 242] = 4;
    table[3 * 256 + 243] = 4;
    table[4 * 256 + 243] = 4;
    table[3 * 256 + 244] = 4;
    table[4 * 256 + 244] = 4;
    table[3 * 256 + 245] = 4;
    table[4 * 256 + 245] = 4;
    table[3 * 256 + 246] = 4;
    table[4 * 256 + 246] = 4;
    table[3 * 256 + 247] = 4;
    table[4 * 256 + 247] = 4;
    table[3 * 256 + 248] = 4;
    table[4 * 256 + 248] = 4;
    table[3 * 256 + 249] = 4;
    table[4 * 256 + 249] = 4;
    table[3 * 256 + 250] = 4;
    table[4 * 256 + 250] = 4;
    table[3 * 256 + 251] = 4;
    table[4 * 256 + 251] = 4;
    table[3 * 256 + 252] = 4;
    table[4 * 256 + 252] = 4;
    table[3 * 256 + 253] = 4;
    table[4 * 256 + 253] = 4;
    table[3 * 256 + 254] = 4;
    table[4 * 256 + 254] = 4;
    table[0 * 256 + 33] = 1;
    table[0 * 256 + 35] = 1;
    table[0 * 256 + 36] = 1;
    table[0 * 256 + 37] = 1;
    table[0 * 256 + 38] = 1;
    table[0 * 256 + 39] = 1;
    table[0 * 256 + 42] = 1;
    table[0 * 256 + 43] = 1;
    table[0 * 256 + 45] = 1;
    table[0 * 256 + 46] = 1;
    table[0 * 256 + 47] = 1;
    table[0 * 256 + 48] = 1;
    table[0 * 256 + 49] = 1;
    table[0 * 256 + 50] = 1;
    table[0 * 256 + 51] = 1;
    table[0 * 256 + 52] = 1;
    table[0 * 256 + 53] = 1;
    table[0 * 256 + 54] = 1;
    table[0 * 256 + 55] = 1;
    table[0 * 256 + 56] = 1;
    table[0 * 256 + 57] = 1;
    table[0 * 256 + 61] = 1;
    table[0 * 256 + 63] = 1;
    table[0 * 256 + 64] = 1;
    table[0 * 256 + 65] = 1;
    table[0 * 256 + 66] = 1;
    table[0 * 256 + 67] = 1;
    table[0 * 256 + 68] = 1;
    table[0 * 256 + 69] = 1;
    table[0 * 256 + 70] = 1;
    table[0 * 256 + 71] = 1;
    table[0 * 256 + 72] = 1;
    table[0 * 256 + 73] = 1;
    table[0 * 256 + 74] = 1;
    table[0 * 256 + 75] = 1;
    table[0 * 256 + 76] = 1;
    table[0 * 256 + 77] = 1;
    table[0 * 256 + 78] = 1;
    table[0 * 256 + 79] = 1;
    table[0 * 256 + 80] = 1;
    table[0 * 256 + 81] = 1;
    table[0 * 256 + 82] = 1;
    table[0 * 256 + 83] = 1;
    table[0 * 256 + 84] = 1;
    table[0 * 256 + 85] = 1;
    table[0 * 256 + 86] = 1;
    table[0 * 256 + 87] = 1;
    table[0 * 256 + 88] = 1;
    table[0 * 256 + 89] = 1;
    table[0 * 256 + 90] = 1;
    table[0 * 256 + 94] = 1;
    table[0 * 256 + 95] = 1;
    table[0 * 256 + 96] = 1;
    table[0 * 256 + 97] = 1;
    table[0 * 256 + 98] = 1;
    table[0 * 256 + 99] = 1;
    table[0 * 256 + 100] = 1;
    table[0 * 256 + 101] = 1;
    table[0 * 256 + 102] = 1;
    table[0 * 256 + 103] = 1;
    table[0 * 256 + 104] = 1;
    table[0 * 256 + 105] = 1;
    table[0 * 256 + 106] = 1;
    table[0 * 256 + 107] = 1;
    table[0 * 256 + 108] = 1;
    table[0 * 256 + 109] = 1;
    table[0 * 256 + 110] = 1;
    table[0 * 256 + 111] = 1;
    table[0 * 256 + 112] = 1;
    table[0 * 256 + 113] = 1;
    table[0 * 256 + 114] = 1;
    table[0 * 256 + 115] = 1;
    table[0 * 256 + 116] = 1;
    table[0 * 256 + 117] = 1;
    table[0 * 256 + 118] = 1;
    table[0 * 256 + 119] = 1;
    table[0 * 256 + 120] = 1;
    table[0 * 256 + 121] = 1;
    table[0 * 256 + 122] = 1;
    table[0 * 256 + 123] = 1;
    table[0 * 256 + 124] = 1;
    table[0 * 256 + 125] = 1;
    table[0 * 256 + 126] = 1;
    table[1 * 256 + 33] = 1;
    table[1 * 256 + 35] = 1;
    table[1 * 256 + 36] = 1;
    table[1 * 256 + 37] = 1;
    table[1 * 256 + 38] = 1;
    table[1 * 256 + 39] = 1;
    table[1 * 256 + 42] = 1;
    table[1 * 256 + 43] = 1;
    table[1 * 256 + 45] = 1;
    table[1 * 256 + 46] = 1;
    table[1 * 256 + 47] = 1;
    table[1 * 256 + 48] = 1;
    table[1 * 256 + 49] = 1;
    table[1 * 256 + 50] = 1;
    table[1 * 256 + 51] = 1;
    table[1 * 256 + 52] = 1;
    table[1 * 256 + 53] = 1;
    table[1 * 256 + 54] = 1;
    table[1 * 256 + 55] = 1;
    table[1 * 256 + 56] = 1;
    table[1 * 256 + 57] = 1;
    table[1 * 256 + 61] = 1;
    table[1 * 256 + 63] = 1;
    table[1 * 256 + 65] = 1;
    table[1 * 256 + 66] = 1;
    table[1 * 256 + 67] = 1;
    table[1 * 256 + 68] = 1;
    table[1 * 256 + 69] = 1;
    table[1 * 256 + 70] = 1;
    table[1 * 256 + 71] = 1;
    table[1 * 256 + 72] = 1;
    table[1 * 256 + 73] = 1;
    table[1 * 256 + 74] = 1;
    table[1 * 256 + 75] = 1;
    table[1 * 256 + 76] = 1;
    table[1 * 256 + 77] = 1;
    table[1 * 256 + 78] = 1;
    table[1 * 256 + 79] = 1;
    table[1 * 256 + 80] = 1;
    table[1 * 256 + 81] = 1;
    table[1 * 256 + 82] = 1;
    table[1 * 256 + 83] = 1;
    table[1 * 256 + 84] = 1;
    table[1 * 256 + 85] = 1;
    table[1 * 256 + 86] = 1;
    table[1 * 256 + 87] = 1;
    table[1 * 256 + 88] = 1;
    table[1 * 256 + 89] = 1;
    table[1 * 256 + 90] = 1;
    table[1 * 256 + 94] = 1;
    table[1 * 256 + 95] = 1;
    table[1 * 256 + 96] = 1;
    table[1 * 256 + 97] = 1;
    table[1 * 256 + 98] = 1;
    table[1 * 256 + 99] = 1;
    table[1 * 256 + 100] = 1;
    table[1 * 256 + 101] = 1;
    table[1 * 256 + 102] = 1;
    table[1 * 256 + 103] = 1;
    table[1 * 256 + 104] = 1;
    table[1 * 256 + 105] = 1;
    table[1 * 256 + 106] = 1;
    table[1 * 256 + 107] = 1;
    table[1 * 256 + 108] = 1;
    table[1 * 256 + 109] = 1;
    table[1 * 256 + 110] = 1;
    table[1 * 256 + 111] = 1;
    table[1 * 256 + 112] = 1;
    table[1 * 256 + 113] = 1;
    table[1 * 256 + 114] = 1;
    table[1 * 256 + 115] = 1;
    table[1 * 256 + 116] = 1;
    table[1 * 256 + 117] = 1;
    table[1 * 256 + 118] = 1;
    table[1 * 256 + 119] = 1;
    table[1 * 256 + 120] = 1;
    table[1 * 256 + 121] = 1;
    table[1 * 256 + 122] = 1;
    table[1 * 256 + 123] = 1;
    table[1 * 256 + 124] = 1;
    table[1 * 256 + 125] = 1;
    table[1 * 256 + 126] = 1;
    table[1 * 256 + 64] = 2;
    table[2 * 256 + 33] = 1;
    table[2 * 256 + 35] = 1;
    table[2 * 256 + 36] = 1;
    table[2 * 256 + 37] = 1;
    table[2 * 256 + 38] = 1;
    table[2 * 256 + 39] = 1;
    table[2 * 256 + 42] = 1;
    table[2 * 256 + 43] = 1;
    table[2 * 256 + 47] = 1;
    table[2 * 256 + 61] = 1;
    table[2 * 256 + 63] = 1;
    table[2 * 256 + 94] = 1;
    table[2 * 256 + 95] = 1;
    table[2 * 256 + 96] = 1;
    table[2 * 256 + 123] = 1;
    table[2 * 256 + 124] = 1;
    table[2 * 256 + 125] = 1;
    table[2 * 256 + 126] = 1;
    table[2 * 256 + 64] = 2;
    table[2 * 256 + 45] = 3;
    table[2 * 256 + 46] = 3;
    table[2 * 256 + 48] = 3;
    table[2 * 256 + 49] = 3;
    table[2 * 256 + 50] = 3;
    table[2 * 256 + 51] = 3;
    table[2 * 256 + 52] = 3;
    table[2 * 256 + 53] = 3;
    table[2 * 256 + 54] = 3;
    table[2 * 256 + 55] = 3;
    table[2 * 256 + 56] = 3;
    table[2 * 256 + 57] = 3;
    table[2 * 256 + 65] = 3;
    table[2 * 256 + 66] = 3;
    table[2 * 256 + 67] = 3;
    table[2 * 256 + 68] = 3;
    table[2 * 256 + 69] = 3;
    table[2 * 256 + 70] = 3;
    table[2 * 256 + 71] = 3;
    table[2 * 256 + 72] = 3;
    table[2 * 256 + 73] = 3;
    table[2 * 256 + 74] = 3;
    table[2 * 256 + 75] = 3;
    table[2 * 256 + 76] = 3;
    table[2 * 256 + 77] = 3;
    table[2 * 256 + 78] = 3;
    table[2 * 256 + 79] = 3;
    table[2 * 256 + 80] = 3;
    table[2 * 256 + 81] = 3;
    table[2 * 256 + 82] = 3;
    table[2 * 256 + 83] = 3;
    table[2 * 256 + 84] = 3;
    table[2 * 256 + 85] = 3;
    table[2 * 256 + 86] = 3;
    table[2 * 256 + 87] = 3;
    table[2 * 256 + 88] = 3;
    table[2 * 256 + 89] = 3;
    table[2 * 256 + 90] = 3;
    table[2 * 256 + 97] = 3;
    table[2 * 256 + 98] = 3;
    table[2 * 256 + 99] = 3;
    table[2 * 256 + 100] = 3;
    table[2 * 256 + 101] = 3;
    table[2 * 256 + 102] = 3;
    table[2 * 256 + 103] = 3;
    table[2 * 256 + 104] = 3;
    table[2 * 256 + 105] = 3;
    table[2 * 256 + 106] = 3;
    table[2 * 256 + 107] = 3;
    table[2 * 256 + 108] = 3;
    table[2 * 256 + 109] = 3;
    table[2 * 256 + 110] = 3;
    table[2 * 256 + 111] = 3;
    table[2 * 256 + 112] = 3;
    table[2 * 256 + 113] = 3;
    table[2 * 256 + 114] = 3;
    table[2 * 256 + 115] = 3;
    table[2 * 256 + 116] = 3;
    table[2 * 256 + 117] = 3;
    table[2 * 256 + 118] = 3;
    table[2 * 256 + 119] = 3;
    table[2 * 256 + 120] = 3;
    table[2 * 256 + 121] = 3;
    table[2 * 256 + 122] = 3;
    table[3 * 256 + 33] = 1;
    table[3 * 256 + 35] = 1;
    table[3 * 256 + 36] = 1;
    table[3 * 256 + 37] = 1;
    table[3 * 256 + 38] = 1;
    table[3 * 256 + 39] = 1;
    table[3 * 256 + 42] = 1;
    table[3 * 256 + 43] = 1;
    table[3 * 256 + 47] = 1;
    table[3 * 256 + 61] = 1;
    table[3 * 256 + 63] = 1;
    table[3 * 256 + 94] = 1;
    table[3 * 256 + 95] = 1;
    table[3 * 256 + 96] = 1;
    table[3 * 256 + 123] = 1;
    table[3 * 256 + 124] = 1;
    table[3 * 256 + 125] = 1;
    table[3 * 256 + 126] = 1;
    table[3 * 256 + 64] = 2;
    table[3 * 256 + 45] = 3;
    table[3 * 256 + 46] = 3;
    table[3 * 256 + 48] = 3;
    table[3 * 256 + 49] = 3;
    table[3 * 256 + 50] = 3;
    table[3 * 256 + 51] = 3;
    table[3 * 256 + 52] = 3;
    table[3 * 256 + 53] = 3;
    table[3 * 256 + 54] = 3;
    table[3 * 256 + 55] = 3;
    table[3 * 256 + 56] = 3;
    table[3 * 256 + 57] = 3;
    table[3 * 256 + 65] = 3;
    table[3 * 256 + 66] = 3;
    table[3 * 256 + 67] = 3;
    table[3 * 256 + 68] = 3;
    table[3 * 256 + 69] = 3;
    table[3 * 256 + 70] = 3;
    table[3 * 256 + 71] = 3;
    table[3 * 256 + 72] = 3;
    table[3 * 256 + 73] = 3;
    table[3 * 256 + 74] = 3;
    table[3 * 256 + 75] = 3;
    table[3 * 256 + 76] = 3;
    table[3 * 256 + 77] = 3;
    table[3 * 256 + 78] = 3;
    table[3 * 256 + 79] = 3;
    table[3 * 256 + 80] = 3;
    table[3 * 256 + 81] = 3;
    table[3 * 256 + 82] = 3;
    table[3 * 256 + 83] = 3;
    table[3 * 256 + 84] = 3;
    table[3 * 256 + 85] = 3;
    table[3 * 256 + 86] = 3;
    table[3 * 256 + 87] = 3;
    table[3 * 256 + 88] = 3;
    table[3 * 256 + 89] = 3;
    table[3 * 256 + 90] = 3;
    table[3 * 256 + 97] = 3;
    table[3 * 256 + 98] = 3;
    table[3 * 256 + 99] = 3;
    table[3 * 256 + 100] = 3;
    table[3 * 256 + 101] = 3;
    table[3 * 256 + 102] = 3;
    table[3 * 256 + 103] = 3;
    table[3 * 256 + 104] = 3;
    table[3 * 256 + 105] = 3;
    table[3 * 256 + 106] = 3;
    table[3 * 256 + 107] = 3;
    table[3 * 256 + 108] = 3;
    table[3 * 256 + 109] = 3;
    table[3 * 256 + 110] = 3;
    table[3 * 256 + 111] = 3;
    table[3 * 256 + 112] = 3;
    table[3 * 256 + 113] = 3;
    table[3 * 256 + 114] = 3;
    table[3 * 256 + 115] = 3;
    table[3 * 256 + 116] = 3;
    table[3 * 256 + 117] = 3;
    table[3 * 256 + 118] = 3;
    table[3 * 256 + 119] = 3;
    table[3 * 256 + 120] = 3;
    table[3 * 256 + 121] = 3;
    table[3 * 256 + 122] = 3;

    table
}
