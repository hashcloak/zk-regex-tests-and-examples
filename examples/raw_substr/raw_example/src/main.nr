global table = comptime { make_lookup_table() };
pub fn regex_match<let N: u32>(input: [u8; N]) -> Vec<BoundedVec<Field, N>> {
    // regex: 1=(a|b) (2=(b|c)+ )+d
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
        if ((s == 2) & (s_next == 3)) {
            if (consecutive_substr == 0) {
                current_substring.push(temp);
                consecutive_substr = 1;
            } else if (consecutive_substr == 1) {
                current_substring.push(temp);
            }
        } else if ((s == 6) & (s_next == 7) | (s == 7) & (s_next == 7)) {
            if (consecutive_substr == 0) {
                current_substring.push(temp);
                consecutive_substr = 1;
            } else if (consecutive_substr == 1) {
                current_substring.push(temp);
            }
        } else if ((s == 8) & (s_next == 9)) {
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
    assert((s == 9) | (s == 10), f"no match: {s}");
    // Add pending substring that hasn't been added
    if consecutive_substr == 1 {
        substrings.push(current_substring);
    }
    substrings
}

comptime fn make_lookup_table() -> [Field; 2816] {
    let mut table = [0; 2816];
    table[9 * 256 + 0] = 10;
    table[10 * 256 + 0] = 10;
    table[9 * 256 + 1] = 10;
    table[10 * 256 + 1] = 10;
    table[9 * 256 + 2] = 10;
    table[10 * 256 + 2] = 10;
    table[9 * 256 + 3] = 10;
    table[10 * 256 + 3] = 10;
    table[9 * 256 + 4] = 10;
    table[10 * 256 + 4] = 10;
    table[9 * 256 + 5] = 10;
    table[10 * 256 + 5] = 10;
    table[9 * 256 + 6] = 10;
    table[10 * 256 + 6] = 10;
    table[9 * 256 + 7] = 10;
    table[10 * 256 + 7] = 10;
    table[9 * 256 + 8] = 10;
    table[10 * 256 + 8] = 10;
    table[9 * 256 + 9] = 10;
    table[10 * 256 + 9] = 10;
    table[9 * 256 + 10] = 10;
    table[10 * 256 + 10] = 10;
    table[9 * 256 + 11] = 10;
    table[10 * 256 + 11] = 10;
    table[9 * 256 + 12] = 10;
    table[10 * 256 + 12] = 10;
    table[9 * 256 + 13] = 10;
    table[10 * 256 + 13] = 10;
    table[9 * 256 + 14] = 10;
    table[10 * 256 + 14] = 10;
    table[9 * 256 + 15] = 10;
    table[10 * 256 + 15] = 10;
    table[9 * 256 + 16] = 10;
    table[10 * 256 + 16] = 10;
    table[9 * 256 + 17] = 10;
    table[10 * 256 + 17] = 10;
    table[9 * 256 + 18] = 10;
    table[10 * 256 + 18] = 10;
    table[9 * 256 + 19] = 10;
    table[10 * 256 + 19] = 10;
    table[9 * 256 + 20] = 10;
    table[10 * 256 + 20] = 10;
    table[9 * 256 + 21] = 10;
    table[10 * 256 + 21] = 10;
    table[9 * 256 + 22] = 10;
    table[10 * 256 + 22] = 10;
    table[9 * 256 + 23] = 10;
    table[10 * 256 + 23] = 10;
    table[9 * 256 + 24] = 10;
    table[10 * 256 + 24] = 10;
    table[9 * 256 + 25] = 10;
    table[10 * 256 + 25] = 10;
    table[9 * 256 + 26] = 10;
    table[10 * 256 + 26] = 10;
    table[9 * 256 + 27] = 10;
    table[10 * 256 + 27] = 10;
    table[9 * 256 + 28] = 10;
    table[10 * 256 + 28] = 10;
    table[9 * 256 + 29] = 10;
    table[10 * 256 + 29] = 10;
    table[9 * 256 + 30] = 10;
    table[10 * 256 + 30] = 10;
    table[9 * 256 + 31] = 10;
    table[10 * 256 + 31] = 10;
    table[9 * 256 + 32] = 10;
    table[10 * 256 + 32] = 10;
    table[9 * 256 + 33] = 10;
    table[10 * 256 + 33] = 10;
    table[9 * 256 + 34] = 10;
    table[10 * 256 + 34] = 10;
    table[9 * 256 + 35] = 10;
    table[10 * 256 + 35] = 10;
    table[9 * 256 + 36] = 10;
    table[10 * 256 + 36] = 10;
    table[9 * 256 + 37] = 10;
    table[10 * 256 + 37] = 10;
    table[9 * 256 + 38] = 10;
    table[10 * 256 + 38] = 10;
    table[9 * 256 + 39] = 10;
    table[10 * 256 + 39] = 10;
    table[9 * 256 + 40] = 10;
    table[10 * 256 + 40] = 10;
    table[9 * 256 + 41] = 10;
    table[10 * 256 + 41] = 10;
    table[9 * 256 + 42] = 10;
    table[10 * 256 + 42] = 10;
    table[9 * 256 + 43] = 10;
    table[10 * 256 + 43] = 10;
    table[9 * 256 + 44] = 10;
    table[10 * 256 + 44] = 10;
    table[9 * 256 + 45] = 10;
    table[10 * 256 + 45] = 10;
    table[9 * 256 + 46] = 10;
    table[10 * 256 + 46] = 10;
    table[9 * 256 + 47] = 10;
    table[10 * 256 + 47] = 10;
    table[9 * 256 + 48] = 10;
    table[10 * 256 + 48] = 10;
    table[9 * 256 + 49] = 10;
    table[10 * 256 + 49] = 10;
    table[9 * 256 + 50] = 10;
    table[10 * 256 + 50] = 10;
    table[9 * 256 + 51] = 10;
    table[10 * 256 + 51] = 10;
    table[9 * 256 + 52] = 10;
    table[10 * 256 + 52] = 10;
    table[9 * 256 + 53] = 10;
    table[10 * 256 + 53] = 10;
    table[9 * 256 + 54] = 10;
    table[10 * 256 + 54] = 10;
    table[9 * 256 + 55] = 10;
    table[10 * 256 + 55] = 10;
    table[9 * 256 + 56] = 10;
    table[10 * 256 + 56] = 10;
    table[9 * 256 + 57] = 10;
    table[10 * 256 + 57] = 10;
    table[9 * 256 + 58] = 10;
    table[10 * 256 + 58] = 10;
    table[9 * 256 + 59] = 10;
    table[10 * 256 + 59] = 10;
    table[9 * 256 + 60] = 10;
    table[10 * 256 + 60] = 10;
    table[9 * 256 + 61] = 10;
    table[10 * 256 + 61] = 10;
    table[9 * 256 + 62] = 10;
    table[10 * 256 + 62] = 10;
    table[9 * 256 + 63] = 10;
    table[10 * 256 + 63] = 10;
    table[9 * 256 + 64] = 10;
    table[10 * 256 + 64] = 10;
    table[9 * 256 + 65] = 10;
    table[10 * 256 + 65] = 10;
    table[9 * 256 + 66] = 10;
    table[10 * 256 + 66] = 10;
    table[9 * 256 + 67] = 10;
    table[10 * 256 + 67] = 10;
    table[9 * 256 + 68] = 10;
    table[10 * 256 + 68] = 10;
    table[9 * 256 + 69] = 10;
    table[10 * 256 + 69] = 10;
    table[9 * 256 + 70] = 10;
    table[10 * 256 + 70] = 10;
    table[9 * 256 + 71] = 10;
    table[10 * 256 + 71] = 10;
    table[9 * 256 + 72] = 10;
    table[10 * 256 + 72] = 10;
    table[9 * 256 + 73] = 10;
    table[10 * 256 + 73] = 10;
    table[9 * 256 + 74] = 10;
    table[10 * 256 + 74] = 10;
    table[9 * 256 + 75] = 10;
    table[10 * 256 + 75] = 10;
    table[9 * 256 + 76] = 10;
    table[10 * 256 + 76] = 10;
    table[9 * 256 + 77] = 10;
    table[10 * 256 + 77] = 10;
    table[9 * 256 + 78] = 10;
    table[10 * 256 + 78] = 10;
    table[9 * 256 + 79] = 10;
    table[10 * 256 + 79] = 10;
    table[9 * 256 + 80] = 10;
    table[10 * 256 + 80] = 10;
    table[9 * 256 + 81] = 10;
    table[10 * 256 + 81] = 10;
    table[9 * 256 + 82] = 10;
    table[10 * 256 + 82] = 10;
    table[9 * 256 + 83] = 10;
    table[10 * 256 + 83] = 10;
    table[9 * 256 + 84] = 10;
    table[10 * 256 + 84] = 10;
    table[9 * 256 + 85] = 10;
    table[10 * 256 + 85] = 10;
    table[9 * 256 + 86] = 10;
    table[10 * 256 + 86] = 10;
    table[9 * 256 + 87] = 10;
    table[10 * 256 + 87] = 10;
    table[9 * 256 + 88] = 10;
    table[10 * 256 + 88] = 10;
    table[9 * 256 + 89] = 10;
    table[10 * 256 + 89] = 10;
    table[9 * 256 + 90] = 10;
    table[10 * 256 + 90] = 10;
    table[9 * 256 + 91] = 10;
    table[10 * 256 + 91] = 10;
    table[9 * 256 + 92] = 10;
    table[10 * 256 + 92] = 10;
    table[9 * 256 + 93] = 10;
    table[10 * 256 + 93] = 10;
    table[9 * 256 + 94] = 10;
    table[10 * 256 + 94] = 10;
    table[9 * 256 + 95] = 10;
    table[10 * 256 + 95] = 10;
    table[9 * 256 + 96] = 10;
    table[10 * 256 + 96] = 10;
    table[9 * 256 + 97] = 10;
    table[10 * 256 + 97] = 10;
    table[9 * 256 + 98] = 10;
    table[10 * 256 + 98] = 10;
    table[9 * 256 + 99] = 10;
    table[10 * 256 + 99] = 10;
    table[9 * 256 + 100] = 10;
    table[10 * 256 + 100] = 10;
    table[9 * 256 + 101] = 10;
    table[10 * 256 + 101] = 10;
    table[9 * 256 + 102] = 10;
    table[10 * 256 + 102] = 10;
    table[9 * 256 + 103] = 10;
    table[10 * 256 + 103] = 10;
    table[9 * 256 + 104] = 10;
    table[10 * 256 + 104] = 10;
    table[9 * 256 + 105] = 10;
    table[10 * 256 + 105] = 10;
    table[9 * 256 + 106] = 10;
    table[10 * 256 + 106] = 10;
    table[9 * 256 + 107] = 10;
    table[10 * 256 + 107] = 10;
    table[9 * 256 + 108] = 10;
    table[10 * 256 + 108] = 10;
    table[9 * 256 + 109] = 10;
    table[10 * 256 + 109] = 10;
    table[9 * 256 + 110] = 10;
    table[10 * 256 + 110] = 10;
    table[9 * 256 + 111] = 10;
    table[10 * 256 + 111] = 10;
    table[9 * 256 + 112] = 10;
    table[10 * 256 + 112] = 10;
    table[9 * 256 + 113] = 10;
    table[10 * 256 + 113] = 10;
    table[9 * 256 + 114] = 10;
    table[10 * 256 + 114] = 10;
    table[9 * 256 + 115] = 10;
    table[10 * 256 + 115] = 10;
    table[9 * 256 + 116] = 10;
    table[10 * 256 + 116] = 10;
    table[9 * 256 + 117] = 10;
    table[10 * 256 + 117] = 10;
    table[9 * 256 + 118] = 10;
    table[10 * 256 + 118] = 10;
    table[9 * 256 + 119] = 10;
    table[10 * 256 + 119] = 10;
    table[9 * 256 + 120] = 10;
    table[10 * 256 + 120] = 10;
    table[9 * 256 + 121] = 10;
    table[10 * 256 + 121] = 10;
    table[9 * 256 + 122] = 10;
    table[10 * 256 + 122] = 10;
    table[9 * 256 + 123] = 10;
    table[10 * 256 + 123] = 10;
    table[9 * 256 + 124] = 10;
    table[10 * 256 + 124] = 10;
    table[9 * 256 + 125] = 10;
    table[10 * 256 + 125] = 10;
    table[9 * 256 + 126] = 10;
    table[10 * 256 + 126] = 10;
    table[9 * 256 + 127] = 10;
    table[10 * 256 + 127] = 10;
    table[9 * 256 + 128] = 10;
    table[10 * 256 + 128] = 10;
    table[9 * 256 + 129] = 10;
    table[10 * 256 + 129] = 10;
    table[9 * 256 + 130] = 10;
    table[10 * 256 + 130] = 10;
    table[9 * 256 + 131] = 10;
    table[10 * 256 + 131] = 10;
    table[9 * 256 + 132] = 10;
    table[10 * 256 + 132] = 10;
    table[9 * 256 + 133] = 10;
    table[10 * 256 + 133] = 10;
    table[9 * 256 + 134] = 10;
    table[10 * 256 + 134] = 10;
    table[9 * 256 + 135] = 10;
    table[10 * 256 + 135] = 10;
    table[9 * 256 + 136] = 10;
    table[10 * 256 + 136] = 10;
    table[9 * 256 + 137] = 10;
    table[10 * 256 + 137] = 10;
    table[9 * 256 + 138] = 10;
    table[10 * 256 + 138] = 10;
    table[9 * 256 + 139] = 10;
    table[10 * 256 + 139] = 10;
    table[9 * 256 + 140] = 10;
    table[10 * 256 + 140] = 10;
    table[9 * 256 + 141] = 10;
    table[10 * 256 + 141] = 10;
    table[9 * 256 + 142] = 10;
    table[10 * 256 + 142] = 10;
    table[9 * 256 + 143] = 10;
    table[10 * 256 + 143] = 10;
    table[9 * 256 + 144] = 10;
    table[10 * 256 + 144] = 10;
    table[9 * 256 + 145] = 10;
    table[10 * 256 + 145] = 10;
    table[9 * 256 + 146] = 10;
    table[10 * 256 + 146] = 10;
    table[9 * 256 + 147] = 10;
    table[10 * 256 + 147] = 10;
    table[9 * 256 + 148] = 10;
    table[10 * 256 + 148] = 10;
    table[9 * 256 + 149] = 10;
    table[10 * 256 + 149] = 10;
    table[9 * 256 + 150] = 10;
    table[10 * 256 + 150] = 10;
    table[9 * 256 + 151] = 10;
    table[10 * 256 + 151] = 10;
    table[9 * 256 + 152] = 10;
    table[10 * 256 + 152] = 10;
    table[9 * 256 + 153] = 10;
    table[10 * 256 + 153] = 10;
    table[9 * 256 + 154] = 10;
    table[10 * 256 + 154] = 10;
    table[9 * 256 + 155] = 10;
    table[10 * 256 + 155] = 10;
    table[9 * 256 + 156] = 10;
    table[10 * 256 + 156] = 10;
    table[9 * 256 + 157] = 10;
    table[10 * 256 + 157] = 10;
    table[9 * 256 + 158] = 10;
    table[10 * 256 + 158] = 10;
    table[9 * 256 + 159] = 10;
    table[10 * 256 + 159] = 10;
    table[9 * 256 + 160] = 10;
    table[10 * 256 + 160] = 10;
    table[9 * 256 + 161] = 10;
    table[10 * 256 + 161] = 10;
    table[9 * 256 + 162] = 10;
    table[10 * 256 + 162] = 10;
    table[9 * 256 + 163] = 10;
    table[10 * 256 + 163] = 10;
    table[9 * 256 + 164] = 10;
    table[10 * 256 + 164] = 10;
    table[9 * 256 + 165] = 10;
    table[10 * 256 + 165] = 10;
    table[9 * 256 + 166] = 10;
    table[10 * 256 + 166] = 10;
    table[9 * 256 + 167] = 10;
    table[10 * 256 + 167] = 10;
    table[9 * 256 + 168] = 10;
    table[10 * 256 + 168] = 10;
    table[9 * 256 + 169] = 10;
    table[10 * 256 + 169] = 10;
    table[9 * 256 + 170] = 10;
    table[10 * 256 + 170] = 10;
    table[9 * 256 + 171] = 10;
    table[10 * 256 + 171] = 10;
    table[9 * 256 + 172] = 10;
    table[10 * 256 + 172] = 10;
    table[9 * 256 + 173] = 10;
    table[10 * 256 + 173] = 10;
    table[9 * 256 + 174] = 10;
    table[10 * 256 + 174] = 10;
    table[9 * 256 + 175] = 10;
    table[10 * 256 + 175] = 10;
    table[9 * 256 + 176] = 10;
    table[10 * 256 + 176] = 10;
    table[9 * 256 + 177] = 10;
    table[10 * 256 + 177] = 10;
    table[9 * 256 + 178] = 10;
    table[10 * 256 + 178] = 10;
    table[9 * 256 + 179] = 10;
    table[10 * 256 + 179] = 10;
    table[9 * 256 + 180] = 10;
    table[10 * 256 + 180] = 10;
    table[9 * 256 + 181] = 10;
    table[10 * 256 + 181] = 10;
    table[9 * 256 + 182] = 10;
    table[10 * 256 + 182] = 10;
    table[9 * 256 + 183] = 10;
    table[10 * 256 + 183] = 10;
    table[9 * 256 + 184] = 10;
    table[10 * 256 + 184] = 10;
    table[9 * 256 + 185] = 10;
    table[10 * 256 + 185] = 10;
    table[9 * 256 + 186] = 10;
    table[10 * 256 + 186] = 10;
    table[9 * 256 + 187] = 10;
    table[10 * 256 + 187] = 10;
    table[9 * 256 + 188] = 10;
    table[10 * 256 + 188] = 10;
    table[9 * 256 + 189] = 10;
    table[10 * 256 + 189] = 10;
    table[9 * 256 + 190] = 10;
    table[10 * 256 + 190] = 10;
    table[9 * 256 + 191] = 10;
    table[10 * 256 + 191] = 10;
    table[9 * 256 + 192] = 10;
    table[10 * 256 + 192] = 10;
    table[9 * 256 + 193] = 10;
    table[10 * 256 + 193] = 10;
    table[9 * 256 + 194] = 10;
    table[10 * 256 + 194] = 10;
    table[9 * 256 + 195] = 10;
    table[10 * 256 + 195] = 10;
    table[9 * 256 + 196] = 10;
    table[10 * 256 + 196] = 10;
    table[9 * 256 + 197] = 10;
    table[10 * 256 + 197] = 10;
    table[9 * 256 + 198] = 10;
    table[10 * 256 + 198] = 10;
    table[9 * 256 + 199] = 10;
    table[10 * 256 + 199] = 10;
    table[9 * 256 + 200] = 10;
    table[10 * 256 + 200] = 10;
    table[9 * 256 + 201] = 10;
    table[10 * 256 + 201] = 10;
    table[9 * 256 + 202] = 10;
    table[10 * 256 + 202] = 10;
    table[9 * 256 + 203] = 10;
    table[10 * 256 + 203] = 10;
    table[9 * 256 + 204] = 10;
    table[10 * 256 + 204] = 10;
    table[9 * 256 + 205] = 10;
    table[10 * 256 + 205] = 10;
    table[9 * 256 + 206] = 10;
    table[10 * 256 + 206] = 10;
    table[9 * 256 + 207] = 10;
    table[10 * 256 + 207] = 10;
    table[9 * 256 + 208] = 10;
    table[10 * 256 + 208] = 10;
    table[9 * 256 + 209] = 10;
    table[10 * 256 + 209] = 10;
    table[9 * 256 + 210] = 10;
    table[10 * 256 + 210] = 10;
    table[9 * 256 + 211] = 10;
    table[10 * 256 + 211] = 10;
    table[9 * 256 + 212] = 10;
    table[10 * 256 + 212] = 10;
    table[9 * 256 + 213] = 10;
    table[10 * 256 + 213] = 10;
    table[9 * 256 + 214] = 10;
    table[10 * 256 + 214] = 10;
    table[9 * 256 + 215] = 10;
    table[10 * 256 + 215] = 10;
    table[9 * 256 + 216] = 10;
    table[10 * 256 + 216] = 10;
    table[9 * 256 + 217] = 10;
    table[10 * 256 + 217] = 10;
    table[9 * 256 + 218] = 10;
    table[10 * 256 + 218] = 10;
    table[9 * 256 + 219] = 10;
    table[10 * 256 + 219] = 10;
    table[9 * 256 + 220] = 10;
    table[10 * 256 + 220] = 10;
    table[9 * 256 + 221] = 10;
    table[10 * 256 + 221] = 10;
    table[9 * 256 + 222] = 10;
    table[10 * 256 + 222] = 10;
    table[9 * 256 + 223] = 10;
    table[10 * 256 + 223] = 10;
    table[9 * 256 + 224] = 10;
    table[10 * 256 + 224] = 10;
    table[9 * 256 + 225] = 10;
    table[10 * 256 + 225] = 10;
    table[9 * 256 + 226] = 10;
    table[10 * 256 + 226] = 10;
    table[9 * 256 + 227] = 10;
    table[10 * 256 + 227] = 10;
    table[9 * 256 + 228] = 10;
    table[10 * 256 + 228] = 10;
    table[9 * 256 + 229] = 10;
    table[10 * 256 + 229] = 10;
    table[9 * 256 + 230] = 10;
    table[10 * 256 + 230] = 10;
    table[9 * 256 + 231] = 10;
    table[10 * 256 + 231] = 10;
    table[9 * 256 + 232] = 10;
    table[10 * 256 + 232] = 10;
    table[9 * 256 + 233] = 10;
    table[10 * 256 + 233] = 10;
    table[9 * 256 + 234] = 10;
    table[10 * 256 + 234] = 10;
    table[9 * 256 + 235] = 10;
    table[10 * 256 + 235] = 10;
    table[9 * 256 + 236] = 10;
    table[10 * 256 + 236] = 10;
    table[9 * 256 + 237] = 10;
    table[10 * 256 + 237] = 10;
    table[9 * 256 + 238] = 10;
    table[10 * 256 + 238] = 10;
    table[9 * 256 + 239] = 10;
    table[10 * 256 + 239] = 10;
    table[9 * 256 + 240] = 10;
    table[10 * 256 + 240] = 10;
    table[9 * 256 + 241] = 10;
    table[10 * 256 + 241] = 10;
    table[9 * 256 + 242] = 10;
    table[10 * 256 + 242] = 10;
    table[9 * 256 + 243] = 10;
    table[10 * 256 + 243] = 10;
    table[9 * 256 + 244] = 10;
    table[10 * 256 + 244] = 10;
    table[9 * 256 + 245] = 10;
    table[10 * 256 + 245] = 10;
    table[9 * 256 + 246] = 10;
    table[10 * 256 + 246] = 10;
    table[9 * 256 + 247] = 10;
    table[10 * 256 + 247] = 10;
    table[9 * 256 + 248] = 10;
    table[10 * 256 + 248] = 10;
    table[9 * 256 + 249] = 10;
    table[10 * 256 + 249] = 10;
    table[9 * 256 + 250] = 10;
    table[10 * 256 + 250] = 10;
    table[9 * 256 + 251] = 10;
    table[10 * 256 + 251] = 10;
    table[9 * 256 + 252] = 10;
    table[10 * 256 + 252] = 10;
    table[9 * 256 + 253] = 10;
    table[10 * 256 + 253] = 10;
    table[9 * 256 + 254] = 10;
    table[10 * 256 + 254] = 10;
    table[0 * 256 + 49] = 1;
    table[1 * 256 + 61] = 2;
    table[2 * 256 + 97] = 3;
    table[2 * 256 + 98] = 3;
    table[3 * 256 + 32] = 4;
    table[4 * 256 + 50] = 5;
    table[5 * 256 + 61] = 6;
    table[6 * 256 + 98] = 7;
    table[6 * 256 + 99] = 7;
    table[7 * 256 + 98] = 7;
    table[7 * 256 + 99] = 7;
    table[7 * 256 + 32] = 8;
    table[8 * 256 + 50] = 5;
    table[8 * 256 + 100] = 9;

    table
}

#[test]
fn test_substr1() {
    // Input for "1=a 2=bbbbbc d"
    let input = [49, 61, 97, 32, 50, 61, 98, 98, 98, 98, 98, 99, 32, 100];
    // This should contain 3 substrings: "a", "bbbbbc", and "d"
    let res = regex_match(input);
    assert(res.len() == 3);

    let substr0 = res.get(0); // "a"
    let substr1 = res.get(1); // "bbbbbc"
    let substr2 = res.get(2); // "d"

    // Check the characters in each substring
    assert(substr0.get(0) == 97); // 'a'

    assert(substr1.get(0) == 98); // 'b'
    assert(substr1.get(5) == 99); // 'c'

    assert(substr2.get(0) == 100); // 'd'
}

#[test]
fn test_substr2() {
    // Input for "1=b 2=bbcb 2=c 2=bb d"
    let input = [49, 61, 98, 32, 50, 61, 98, 98, 99, 98, 32, 50, 61, 99, 32, 50, 61, 98, 98, 32, 100];
    // This should contain 5 substrings: "b", "bbcb", "c", "bb", and "d"
    let res = regex_match(input);
    assert(res.len() == 5);

    let substr0 = res.get(0); // "b"
    let substr1 = res.get(1); // "bbcb"
    let substr2 = res.get(2); // "c"
    let substr3 = res.get(3); // "bb"
    let substr4 = res.get(4); // "d"

    // Check the characters in each substring
    assert(substr0.get(0) == 98); // 'b'

    assert(substr1.get(0) == 98); // 'b'
    assert(substr1.get(3) == 98); // 'b'
    assert(substr1.get(2) == 99); // 'c'

    assert(substr2.get(0) == 99); // 'c'

    assert(substr3.get(0) == 98); // 'b'
    assert(substr3.get(1) == 98); // 'b'

    assert(substr4.get(0) == 100); // 'd'
}

#[test(should_fail)]
fn test_invalid() {
    // "abc"
    let input: [u8; 3] = [97, 98, 99];

    let res = regex_match(input);
}
