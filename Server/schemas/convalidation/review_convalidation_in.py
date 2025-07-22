from pydantic import BaseModel
 
class ReviewConvalidationIn(BaseModel):
    id_convalidation: int
    id_convalidation_state: int
    review_comments: str
    id_reviewed_by: int 