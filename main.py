from dataclasses import dataclass
from dataclasses import asdict
import json

@dataclass(frozen=True)
class UserClass:
    user_id:None| str = None
    thread_id:None| str = None
    document:None| bytes = None
    doc_id:None| str = None
def dict_maker(ctx:UserClass)->json:
    return asdict(ctx)


ctx =UserClass(
    user_id="oqoihd;akjs;oij;'klsjf'asopfj",
    thread_id="ower0o3sfq[984rpask[qw,e/Q?w.,eq';w]]",
    doc_id="eurquipeiourpoi3u02[]"
)
ctx = dict_maker(ctx=ctx)
print(ctx)

print(ctx["user_id"])