from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    pageindex_api_key: str
    aws_region: str

    class Config:
        env_file = ".env"


settings = Settings()
