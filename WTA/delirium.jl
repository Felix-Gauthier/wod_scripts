using DataStructures
using Random
using Statistics

struct Delirium_Effect
    willpower::Int
    forget::String
    reaction_short::String
    reaction_long::String
end
willpower(x::Delirium_Effect) = x.willpower
forget(x::Delirium_Effect) = x.forget
reaction_short(x::Delirium_Effect) = x.reaction_short
reaction_long(x::Delirium_Effect) = x.reaction_long

wd_dict = OrderedDict(
    0.1=> Delirium_Effect(1,"Yes","Catatonic Fear","The human faints, or collapses in fear"),
    0.3=> Delirium_Effect(2,"Yes","Panic", "The human bolts, trying to put as much distance
    between himself and the Garou as possible"),
    0.48=> Delirium_Effect(3,"Yes","Disbelief"," The human retreats to a corner to avoid the
    “hallucination” until it passes, but doesn’t collapse in fear."),
    0.63=> Delirium_Effect(4,"Yes","Berserk"," The human attacks, be it firing a gun (he won’t
    have enough presence of mind to reload, however),
    throwing crockery or even leaping at the 'monster'."),
    0.76=> Delirium_Effect(5,"Yes","Terror"," Much like panic, except with rational thought.
    The human is able to think enough to lock doors behind
    him or to get in a car and flee."),
    0.86=> Delirium_Effect(6,"Yes","Conciliatory"," The human will try to plead and bargain with
    the Garou, doing anything possible so as not to get hurt."),
    0.93=> Delirium_Effect(7,"No, but will rationalize","Controlled Fear"," Although terrified, he does not panic. The
    human will flee or fight as appropriate, but remains in control
    of his actions."),
    0.98=> Delirium_Effect(8,"No, but will rationalize","Curiosity"," These people are dangerous, because they
    remember what they saw (more-or-less), and they might
    well investigate the matter further."),
    0.995=> Delirium_Effect(9,"No","Bloodlust"," This human refuses to take anymore. She is
    afraid but angry, and she will remember the Garou and
    probably even try to hunt it down."),
    1.0=> Delirium_Effect(10,"No","No reaction"," The human is not the slightest bit afraid or
    bothered by the Garou. Even Kinfolk aren’t this stoic, so
    Garou tend to be very suspicious of such folks."))

function delirium(n::Int)
    @assert n >= 1 "n must be greater than zero (passed: $(@show(n)))"
    _d0 = OrderedDict(counter(get_delirium.(rand(0.0:0.001:1.0,n))))
    return sort(_d0, by=x->_d0[x], rev=true)
end

function get_delirium(val)
    for key in collect(keys(wd_dict))
        if val <= key
            return wd_dict[key]
        end
    end
    error("WTF: $val") # should not reach
end

function get_msg(de::Delirium_Effect,n::Int; short=true)
    str = "\n- $n humans have willpower($(willpower(de))): $(reaction_short(de))"
    str *= "\n  Forget? $(forget(de))"
    str *= short ? "" : "\n  Description: $(reaction_long(de))"
    return str
end

function get_delirium_effects(number_of_humans::Int; short=true)
    distribution = delirium(number_of_humans)
    msg = """
    The group of $number_of_humans humans reacted to delirium from the Garou(s) form!
    ---"""
    for key in collect(keys(distribution))
        msg *= get_msg(key, distribution[key]; short)
    end
    println(msg)
end


