using DataStructures
using Random
using Statistics

struct Delirium_Effect
    forget::String
    reaction_short::String
    reaction_long::String
end
forget(x::Delirium_Effect) = x.forget
reaction_short(x::Delirium_Effect) = x.reaction_short
reaction_long(x::Delirium_Effect) = x.reaction_long

probs = [0.1,0.3,0.48,0.63,0.76,0.86,0.93,0.995,1.0]

de_dict = OrderedDict(
    1=> Delirium_Effect("Yes","Catatonic Fear","The human faints, or collapses in fear"),
    2=> Delirium_Effect("Yes","Panic", "The human bolts, trying to put as much distance
    between himself and the Garou as possible"),
    3=> Delirium_Effect("Yes","Disbelief"," The human retreats to a corner to avoid the
    “hallucination” until it passes, but doesn’t collapse in fear."),
    4=> Delirium_Effect("Yes","Berserk"," The human attacks, be it firing a gun (he won’t
    have enough presence of mind to reload, however),
    throwing crockery or even leaping at the 'monster'."),
    5=> Delirium_Effect("Yes","Terror"," Much like panic, except with rational thought.
    The human is able to think enough to lock doors behind
    him or to get in a car and flee."),
    6=> Delirium_Effect("Yes","Conciliatory"," The human will try to plead and bargain with
    the Garou, doing anything possible so as not to get hurt."),
    7=> Delirium_Effect("No, but will rationalize","Controlled Fear"," Although terrified, he does not panic. The
    human will flee or fight as appropriate, but remains in control
    of his actions."),
    8=> Delirium_Effect("No, but will rationalize","Curiosity"," These people are dangerous, because they
    remember what they saw (more-or-less), and they might
    well investigate the matter further."),
    9=> Delirium_Effect("No","Bloodlust"," This human refuses to take anymore. She is
    afraid but angry, and she will remember the Garou and
    probably even try to hunt it down."),
    10=> Delirium_Effect("No","No reaction"," The human is not the slightest bit afraid or
    bothered by the Garou. Even Kinfolk aren’t this stoic, so
    Garou tend to be very suspicious of such folks."))

function delirium(n::Int)
    @assert n >= 1 "n must be greater than zero (passed: $(@show(n)))"
    cc = collect(counter(get_delirium.(rand(0.0:0.001:1.0,n))))
    return sort(cc, by=x->x[2], rev=true)
end

function get_delirium(val)
    for i in 1:length(probs)
        val <= probs[i] && return i
    end
    error("WTF: $val") # should not reach
end

function get_msg(will::Int,n::Int,de::Delirium_Effect; short=true)
    str = "\n- $n humans have willpower($will): $(reaction_short(de))"
    str *= "\n  Forget? $(forget(de))"
    str *= short ? "" : "\n  Description: $(reaction_long(de))"
    return str
end

function get_delirium_effects(number_of_humans::Int; short=true)
    distribution = delirium(number_of_humans)
    msg = """
    The group of $number_of_humans humans reacted to delirium from the Garou(s) form!
    ---"""
    for (will,nbr) in distribution
        msg *= get_msg(will,nbr,de_dict[will]; short)
    end
    println(msg)
end


