Config = {
  Item = 'slimjim',  -- Which useable item lets us break into a vehicle?
  Duration = {
    Minimum = 20000, -- Minimum number of milliseconds to unlock a vehicle.
    Maximum = 60000, -- Maximum number of milliseconds to unlock a vehicle.
  },
  Alert = {
    Enabled = true, -- Can this action cause an automatic police alert?
  },
  Probability = {
    Success = 0.8, -- How likely it is (0.0 - 1.0) that we succeed.
    Alert = 0.66,  -- If a police alert can happen, how likely is it?
  },
  Exempt = {
    Classes = { -- All vehicle classes that cannot be broken into.
      8,
      13,
      15,
      16,
      17,
      18,
      19,
      21,
    },
    Models = {
      `BLAZER`,
    },
  },
}
